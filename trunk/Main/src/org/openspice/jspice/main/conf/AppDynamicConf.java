/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2003, Stephen F. K. Leach
 *
 * 	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 * 	the Free Software Foundation; either version 2 of the License, or
 * 	(at your option) any later version.
 *
 * 	This program is distributed in the hope that it will be useful,
 * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
 * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 * 	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package org.openspice.jspice.main.conf;

import org.openspice.alert.Alert;
import org.openspice.jspice.class_builder.JSpiceClassLoader;
import org.openspice.jspice.conf.ConfTokenizer;
import org.openspice.jspice.conf.DynamicConf;
import org.openspice.jspice.conf.InventoryConf;
import org.openspice.jspice.conf.LoaderBuilderRecord;
import org.openspice.jspice.conf.StaticConf;
import org.openspice.jspice.main.pragmas.StylePragma;
import org.openspice.jspice.run.jline_stuff.PrefixFilterAccumulator;
import org.openspice.jspice.run.manual.FileManual;
import org.openspice.jspice.run.manual.Manual;
import org.openspice.tools.ImmutableSetOfBoolean;
import org.openspice.tools.Print;
import org.openspice.vfs.VFile;
import org.openspice.vfs.VFolder;
import org.openspice.vfs.file.FileVVolume;

import java.io.File;
import java.util.*;
import java.util.regex.Pattern;

public final class AppDynamicConf implements DynamicConf {

	//	---- File and Folder Naming Conventions ----
	//	I suspect that almost all of the following should be relegated to
	//	parameters in the jspice.conf file.

	private static final String auto_folder_suffix = "-auto";
	private static final Pattern auto_folder_pattern = Pattern.compile( "^([a-zA-Z]\\w*)" + auto_folder_suffix + "$" );


//	private static final String inventory_conf_file_name = FixedConf.INVENTORY_NAM + "." + FixedConf.CONF_EXT;
	private static final File personal_inventory = new File( ".jspice", StaticConf.INVENTORY_NAM );

	//	---oooOOOooo---

	String prompt_base = StaticConf.BASE_PROMPT + " ";

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getPrompt()
	 */
	public String getPrompt() {
		return this.prompt_base;
	}

	//	---oooOOOooo---


	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getLoadConfFileName()
	 */
	public final String getLoadConfFileName() {
		return StaticConf.load_conf_file_name;
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getLoadFolderName()
	 */
	public final String getLoadFolderName() {
		return StaticConf.load_folder_nam;
	}

	public static final String getLoadSpiceFileName() {
		return StaticConf.load_spice_file_name;
	}

	public static final Pattern getAutoFolderPattern() {
		return auto_folder_pattern;
	}

	private static final char dir_extn_char = '-';
	private static final char file_extn_char = '.';

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getExtensionChar(java.io.File)
	 */
	public char getExtensionChar( final File f ) {
		 return f.isDirectory() ? dir_extn_char : file_extn_char;
	}

	//	---- Inventories ----

	private Set< InventoryConf > inventories = (
		new TreeSet< InventoryConf >(
			new Comparator< InventoryConf >() {
				public int compare( final InventoryConf a, final InventoryConf b ) {
					return a.getUniqueID().compareTo( b.getUniqueID() );
				}
			}
		)
	);

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getInventories()
	 */
	public Set getInventories() {
		return inventories;
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#installInventoryConf(org.openspice.vfs.VFolder)
	 */
	public void installInventoryConf( final VFolder inventory_path ) {
		if ( !inventory_path.getVFileRef( StaticConf.std_inventory_name, StaticConf.CONF_EXT ).exists() ) {
			new Alert( "Missing inventory configuration file" ).culprit( "path", inventory_path ).warning();
		}
		final InventoryConf invc = new InventoryConf( this, inventory_path );
		if ( !this.inventories.contains( invc ) ) {
			//	Get nicknames that are in use.
			final Set< String > nicknames = new HashSet< String >();
			for ( InventoryConf icf : this.inventories ) {
				nicknames.add( icf.getNickname() );
			}
			//	Add immediately, to inhibit duplicate loading attempts.
			this.inventories.add( invc );
			//	Complete 2nd (& more expensive) phase of life cycle.
			Print.println( Print.CONFIG, "loading inventory: " + inventory_path );
			invc.loadInventory();
			//	Now enforce a unique nickname.
			String nn = invc.getNickname();
			while ( nicknames.contains( nn )  ) {
				nn += "*";
			}
			invc.setNickname( nn );
		}
	}


	public final String getInventoryConfNam() {
		return StaticConf.INVENTORY_NAM;
	}

	public final VFolder lookupInventoryNickname( final String nickname ) {
		final FileVVolume root = new FileVVolume( new File( "/" )  );
		if ( "standard".equals( nickname ) ) {
			return root.getVFolderFromPath( "usr/local/jspice/inventory" );
		} else if ( "local".equals( nickname ) ) {
			return root.getVFolderFromPath( "etc/jspice/inventory" );
		} else if ( "personal".equals( nickname ) ) {
			return root.getVFolderRefFromPath( System.getProperty( "user.home" ) ).getVFolderRefFromPath( personal_inventory.getPath() ).getVFolder( ImmutableSetOfBoolean.EITHER, false );
		} else {
			throw new Alert( "Invalid inventory nickname" ).culprit( "nickname", nickname ).mishap();
		}
	}

	//
	//	Given a package name, locate the package folder.  The answer must be unqiue
	//	even after searching every inventory.
	//
	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#locatePackage(java.lang.String)
	 */
	final public VFolder locatePackage( final String pkg_name ) {
		VFolder answer = null;
		for ( Iterator it = this.inventories.iterator(); it.hasNext(); ) {
			final InventoryConf iconf = (InventoryConf)it.next();
			final VFolder f = iconf.locatePackageFolder( pkg_name );
			if ( answer == null ) {
				answer = f;
			} else if ( f != null ) {
				new Alert( "Duplicate package folders" ).
				culprit( "pkg_name", pkg_name ).
				culprit( "folder", answer ).
				culprit( "folder", f ).
				mishap();
			}
		}
		return answer;
	}

	//	---- getLoaderClassName ----

	//	Map< String, LoaderBuilderRecord >
	private final Map< String, LoaderBuilderRecord > extnMap = new TreeMap< String, LoaderBuilderRecord >();

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getLoaderBuilderClassName(java.lang.String, boolean)
	 */
	public String getLoaderBuilderClassName( final String extn, final boolean null_allowed ) {
		final LoaderBuilderRecord r = extn != null ? (LoaderBuilderRecord)this.extnMap.get( extn ) : null;
		if ( r !=  null ) return r.getClassName();
		if ( null_allowed )	return null;
		throw new Alert( "No loader associated with this extension" ).culprit( "extension", extn ).mishap();
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getAutoloaders()
	 */
	public Collection getAutoloaders() {
		return this.extnMap.values();
	}


	//	---- Global Modes ----

	boolean is_debugging = "on".equals( System.getProperty( StaticConf.getPropertyName( "debug" ) ) );
	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#isDebugging()
	 */
	public boolean isDebugging() {
		return is_debugging;
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#setIsDebugging(boolean)
	 */
	public void setIsDebugging( final boolean _is_debugging ) {
		this.is_debugging = _is_debugging;
	}

	//	---- Self Homing ----


	private final VFolder jspice_home;
	private VFile jspice_conf_vfile;

	private static File home() {
		final String jhomef = System.getProperty( StaticConf.getPropertyName( "home" ) );
		if ( jhomef == null ) {
			return null;
		} else {
			final File jhome = new File( jhomef );
			return jhome.canRead() ? jhome : null;
		}
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getUserHome()
	 */
	public VFolder getUserHome() {
		return new FileVVolume( new File( System.getProperty( "user.home" ) ) ).getRootVFolder();
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getHome()
	 */
	public VFolder getHome() {
		return this.jspice_home;
	}




	//	---- Find help file ----

	//	Maps commands/manual names into Manuals
	final Map< String, FileManual > manuals = new HashMap< String, FileManual >();
	{
		this.manuals.put( "help", new FileManual( this, "help", "jspice" ) );
		this.manuals.put( "licence", new FileManual( this, "licence", "licences", "jspice" ) );
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getManualByName(java.lang.String)
	 */
	public Manual getManualByName( final String mname ) {
		return (Manual)manuals.get( mname );
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#findManualCompletions(org.openspice.jspice.main.jline_stuff.PrefixFilterAccumulator)
	 */
	public void findManualCompletions( final PrefixFilterAccumulator acc ) {
		acc.addAll( this.manuals.keySet() );
	}

	// 	---- Licence File ----

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getLicenceFile()
	 */
	public VFile getLicenceFile() {
		return this.jspice_home.getVFile( StaticConf.licence_nam, StaticConf.TXT_EXT );
	}

	//	---- Environment Variables ----
	//	The environment is passed in via -D parameters.  Java is pants.

	private Map< String, String > env_map = null;
	private static final Pattern wboundary = Pattern.compile( "[\\n\\r]+" );

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getEnvMap()
	 */
	public Map getEnvMap() {
		if ( this.env_map != null ) return this.env_map;
		this.env_map = new TreeMap< String, String >();
		final String env = System.getProperty( StaticConf.getPropertyName( "env" ) );
		if ( env == null ) return this.env_map;

		final String[] bindings = wboundary.split( env );
		for ( int i = 0; i < bindings.length; i++ ) {
			final String b = bindings[ i ];
			final int n = b.indexOf( '=' );
			if ( n >= 0 ) {
				final String key = b.substring( 0, n );
				final String val = b.substring( n+1 );
				this.env_map.put( key, val );
			}
		}

		return this.env_map;
	}

	//	---- Entity Tables ----

	final Map< String, Character > entityToStringMap = new HashMap< String, Character >();	//	Map< String, Character >
	final Map< Character, String > charToEntityMap = new HashMap< Character, String >();		//	Map< Character, String >

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#decode(java.lang.String)
	 */
	public Character decode( final String s ) {
		return (Character)this.entityToStringMap.get( s );
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#encode(char)
	 */
	public String encode( final char ch ) {
		return (String)this.charToEntityMap.get( new Character( ch ) );
	}

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#listEntities(java.lang.String)
	 */
	public List listEntities( final String regex ) {
		final List< String > answer = new ArrayList< String >();
		for ( Iterator it = this.charToEntityMap.values().iterator(); it.hasNext(); ) {
			final String ent = (String)it.next();
			if ( ent.matches( regex ) ) {
				answer.add( ent );
			}
		}
		return answer;
	}

	//	---- Constructor ----



	/**
	 * This is placeholding stuff at present.  Obviously enough the configuration
	 * file should have a unified format.  However, for the moment the basic rules are:-
	 * 	1.	'#' is an end of line comment
	 * 	2.	data entry lines are
	 *          AddLoaderBuilder EXTN CLASSNAME
	 *          Entity NAME HEX_CODE
	 *          Prompt STRING
	 * 	3.	blank lines are discarded
	 */
	private final void parseJSpiceConf( final VFile conf_file ) { //, final Map env_map, final Map entity_to_code_map, final Map code_to_entity_map ) {
		final ConfTokenizer conft = new ConfTokenizer( conf_file.readContents() );
		for ( final List< String > list = new ArrayList< String >(); conft.next( list ) != null; list.clear() ) {
			final int list_size = list.size();	//	Guaranteed to be at least length 1.
			final String command = (String)list.get( 0 );
			if ( "AddLoaderBuilder".equals( command ) && 3 <= list_size && list_size <= 4 ) {
				final String extn = (String)list.get( 1 );
				final String cname = (String)list.get( 2 );
				final String comment = list_size == 3 ? "(no info)" : (String)list.get( 3 );
				this.extnMap.put( extn, new LoaderBuilderRecord( extn, cname, comment ) );
			} else if ( "Entity".equals( command ) && list_size == 3 ) {
				final String name = (String)list.get( 1 );
				final String hex_code_str = (String)list.get( 2 );
				if ( hex_code_str.length() > 0 && hex_code_str.charAt( 0 ) == 'U' ) {
					final char code = (char)Integer.parseInt( hex_code_str.substring( 1 ), 16 );
					final Character ch = new Character( code );
					this.entityToStringMap.put( name, ch );
					this.charToEntityMap.put( ch, name );
				} else {
					new Alert( "Unrecognised entity code" ).culprit( "name", name ).culprit( "code", hex_code_str ).warning();
				}
			} else if ( "Prompt".equals( command ) && list_size == 2 ) {
				this.prompt_base = (String)list.get( 1 );
			} else if ( "StyleWarning".equals( command ) ) {
				list.remove( 0 );
				new StylePragma().enable( list );
			} else {
				final Object directive = list.remove( 0 );
				new Alert( "Unrecognized directive in JSpice conf file" ).culprit( "directive", directive ).culprit_list( list ).mishap();
			}
		}
	}

	public static JSpiceClassLoader jspice_class_loader = new JSpiceClassLoader();

	/* (non-Javadoc)
	 * @see org.openspice.jspice.conf.DynamicConf#getClassLoader()
	 */
	public JSpiceClassLoader getClassLoader() {
		return jspice_class_loader;
	}


	public AppDynamicConf() {
//		this.jspice_home = UrlVFolderRef.make( "ftp://heather:lucy@127.0.0.1" + home() + "/" ).getVFolder( ImmutableSetOfBoolean.ONLY_TRUE,  false );
		final File h = home();
		if ( h == null ) {
			final String key = StaticConf.getPropertyName( "home" ) ;
			final String val = System.getProperty( key );
			final String path = new File( val ).getAbsolutePath();
			new Alert( "Cannot determine JSpice home directory" ).culprit( key, path ).mishap();
		}
		this.jspice_home = new FileVVolume( home() ).getRootVFolderRef().getVFolder( ImmutableSetOfBoolean.ONLY_TRUE, false );
		if ( this.jspice_home == null ) {
			new Alert( "Cannot locate JSpice home directory" ).warning();
		}
		this.jspice_conf_vfile = this.jspice_home.getVFile( StaticConf.JSPICE_CONF_NAM, StaticConf.CONF_EXT );
		if ( this.jspice_conf_vfile == null ) {
			new Alert( "Cannot locate JSpice startup file (jspice.conf)" ).mishap();
		}

		//	Parse the JConf file.
		this.parseJSpiceConf( this.jspice_conf_vfile );

		Print.println( Print.CONFIG, "Installing std inventory ..." );
		this.installInventoryConf( this.jspice_home.getVFolder( StaticConf.std_inventory_name, null ) );
		Print.println( Print.CONFIG, "... installed" );

		{
			//	todo: move the strings constants to FixedConf
			final VFile vfile = this.getUserHome().getVFolderRef().getVFileFromPath( ".jspice/jspice.conf" );
			if ( vfile != null ) this.parseJSpiceConf( vfile );
		}
//		try {
//			this.parseJSpiceConf( new ZipVVolume( new ZipFile( new File( "/tmp/foo.zip" ) ) ).getVFileFromPath( ".jspice/jspice.conf" ) );
//		} catch ( IOException e ) {
//			throw new RuntimeException( e );
//		}
	}

}
