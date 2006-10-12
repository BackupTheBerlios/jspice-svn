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
package org.openspice.jspice.built_in;

import org.openspice.jspice.datatypes.proc.Unary0InvokeProc;
import org.openspice.jspice.datatypes.Symbol;
import org.openspice.jspice.datatypes.elements.SemiCompactXmlElement;
import org.openspice.jspice.datatypes.elements.XmlElement;
import org.openspice.jspice.tools.*;

import java.util.*;


/*
	1. 	A sequence of vertically stacked blocks.
	2.	Indented block
	3.	String <- a block consisting of a single line
*/

public class PrettyPrint extends Unary0InvokeProc {

	public static final int STANDARD_WIDTH = 80;
	public static final String INDENT_STRING = "    ";
	public static final int INDENT_STEP = INDENT_STRING.length();

	static abstract class Block {
		abstract void prettyPrint( final Consumer cuchar, final int indent, final String sfx );
		abstract int compactSize();
		abstract String compactString();
		abstract boolean compactSizeLTE( final int width );
		abstract Block tryToCompact( final int width );
	}

	static class StringBlock extends Block {
		final String string;

		protected StringBlock( String string ) {
			this.string = string;
		}

		void prettyPrint( final Consumer cuchar, final int indent, final String sfx ) {
			for ( int i = 0; i < indent; i++ ) {
				cuchar.outCharSequence( INDENT_STRING );
			}
			cuchar.outCharSequence( this.string );
			cuchar.outCharSequence( sfx );
			cuchar.ln();
		}

		int compactSize() {
			return this.string.length();
		}

		boolean compactSizeLTE( int width ) {
			return this.string.length() <= width;
		}

		String compactString() {
			return this.string;
		}

		Block tryToCompact( final int width ) {
			return this;
		}
	}

	static class IndentedBlock extends Block {
		final Block block;

		protected IndentedBlock( Block block ) {
			this.block = block;
		}

		void prettyPrint( final Consumer cuchar, final int indent, final String sfx ) {
			this.block.prettyPrint( cuchar, indent + 1, sfx );
		}

		int compactSize() {
			return this.block.compactSize();
		}

		boolean compactSizeLTE( int width ) {
			return this.block.compactSizeLTE( width );
		}

		String compactString() {
			return this.block.compactString();
		}

		Block tryToCompact( final int width ) {
			return new IndentedBlock( this.block.tryToCompact( width - INDENT_STEP ) );
		}
	}

	static class SeqBlock extends Block {
		final List list = new ArrayList();

		protected SeqBlock() {
		}

		void add( final Block block ) {
			this.list.add( block );
		}

		void prettyPrint( final Consumer cuchar, final int indent, final String sfx ) {
			for ( Iterator it = this.list.iterator(); it.hasNext(); ) {
				final Block b = (Block)it.next();
				b.prettyPrint( cuchar, indent, ( it.hasNext() ? "" : sfx ) );
			}
		}

		int compactSize() {
			int total = 0;
			for ( Iterator it = this.list.iterator(); it.hasNext(); ) {
				total += ((Block)it.next()).compactSize() + 1;
			}
			if ( total > 0 ) {
				total -= 1;
			}
			return total;
		}

		boolean compactSizeLTE( int width ) {
			for ( Iterator it = this.list.iterator(); it.hasNext(); ) {
				final Block b = (Block)it.next();
				if ( !b.compactSizeLTE( width ) ) return false;
				width -= b.compactSize();
				if ( it.hasNext() ) width -= 1;
				if ( width < 0 ) return false;
			}
			return true;
		}

		String compactString() {
			final StringBuffer b = new StringBuffer();
			String gap = "";
			for ( Iterator it = this.list.iterator(); it.hasNext(); ) {
				b.append( gap );
				b.append( ((Block)it.next()).compactString() );
				gap = " ";
			}
			return b.toString();
		}

		Block tryToCompact( final int width ) {
			if ( this.compactSize() < width ) {
				return new StringBlock( this.compactString() );
			} else {
				final SeqBlock s = new SeqBlock();
				for ( Iterator it = this.list.iterator(); it.hasNext(); ) {
					s.add( ((Block)it.next()).tryToCompact( width - INDENT_STEP ) );
				}
				return s;
			}
		}

	}

	static class Suffix extends Block {
		final Block block;
		final String suffix;

		public Suffix( Block block, String suffix ) {
			this.block = block;
			this.suffix = suffix;
		}

		void prettyPrint( final Consumer cuchar, final int indent, final String sfx ) {
			this.block.prettyPrint( cuchar, indent, this.suffix + " " + sfx );
		}

		int compactSize() {
			return this.block.compactSize() + this.suffix.length();
		}

		String compactString() {
			return this.block.compactString() + this.suffix;
		}

		boolean compactSizeLTE( int width ) {
			final int w = width - this.suffix.length();
			if( w < 0 ) return false;
			return this.block.compactSizeLTE( w );
		}

		Block tryToCompact( final int width ) {
			if ( this.compactSize()  < width ) {
				return new StringBlock( this.compactString() );
			} else {
				return (
					new Suffix(
						this.block.tryToCompact( width - INDENT_STEP - this.suffix.length() ),
						this.suffix
					)
				);
			}
		}
	}

	static class Infix extends Block {
		final Block lhs;
		final String operator;
		final Block rhs;

		public Infix( Block lhs, String operator, Block rhs ) {
			this.lhs = lhs;
			this.operator = operator;
			this.rhs = rhs;
		}

		void prettyPrint( final Consumer cuchar, final int indent, final String sfx ) {
			this.lhs.prettyPrint( cuchar, indent, " " + this.operator );
			this.rhs.prettyPrint( cuchar, indent, sfx );
		}

		int compactSize() {
			return this.lhs.compactSize() + 1 + this.operator.length() + 1 + this.rhs.compactSize();
		}

		boolean compactSizeLTE( int width ) {
			width -= this.operator.length() + 2;
			if ( width < 0 ) return false;
			if ( ! this.lhs.compactSizeLTE( width ) ) return false;
			width -= this.lhs.compactSize();
			if ( width < 0 ) return false;
			return this.rhs.compactSizeLTE( width );
		}

		String compactString() {
			return this.lhs.compactString() + " " + this.operator + " " + this.rhs.compactString();
		}

		Block tryToCompact( final int width ) {
			if ( this.compactSizeLTE( width ) ) {
				return new StringBlock( this.compactString() );
			} else {
				return new Infix( this.lhs.tryToCompact( width - this.operator.length() ), this.operator, this.rhs.tryToCompact( width ) );
			}
		}
	}

	private static String startTag( final XmlElement x ) {
		final StringBufferConsumer cuchar = new StringBufferConsumer();

		cuchar.out( '<' );
		PrintTools.printTo( cuchar, x.getName() );

		for ( Iterator it = x.attributesIterator( false ); it.hasNext(); ) {
			final Map.Entry e = (Map.Entry)it.next();
			cuchar.out( ' ' );
			cuchar.outCharSequence( ((Symbol)e.getKey()).getInternedString() );
			cuchar.out( '=' );
			cuchar.out( '"' );
			PrintTools.printTo( cuchar, e.getValue() );
			cuchar.out( '"' );
		}

		cuchar.out( '>' );
		return (String)cuchar.close();
	}

	private static String endTag( final XmlElement x ) {
		return "</" + x.getName() + ">";
	}

	private static Block layoutXmlElement( final XmlElement x ) {
		if ( x.isEmpty() ) {
			return new StringBlock( PrintTools.printToString( x ) );
		} else {
			final String start_tag = startTag( x );
			final String end_tag = endTag( x );
			final SeqBlock s = new SeqBlock();
			s.add(  new StringBlock( start_tag ) );
			final SeqBlock t = new SeqBlock();
			s.add( new IndentedBlock( t ) );

			for ( Iterator it = x.childrenIterator( false ); it.hasNext(); ) {
				final Block b = layout( it.next() );
				t.add( it.hasNext() ? new Suffix( b, "," ) : b );
			}

			s.add(  new StringBlock( end_tag ) );
			return s;
		}
	}

	public static final Block layout( final Object x ) {
		if ( x instanceof List ) {
			final SeqBlock s = new SeqBlock();
			s.add(  new StringBlock( "{" ) );
			final SeqBlock t = new SeqBlock();
			s.add( new IndentedBlock( t ) );
			for ( Iterator it = ((List)x).iterator(); it.hasNext(); ) {
				final Block b = layout( it.next() );
				t.add( it.hasNext() ? new Suffix( b, "," ) : b );
			}
			s.add(  new StringBlock( "}" ) );
			return s;
		} else if ( x instanceof Map ) {
			final SeqBlock s = new SeqBlock();
			s.add(  new StringBlock( "{%" ) );
			final SeqBlock t = new SeqBlock();
			s.add( new IndentedBlock( t ) );
			for ( Iterator it = ((Map)x).entrySet().iterator(); it.hasNext(); ) {
				final Map.Entry me = (Map.Entry)it.next();
				final Object key = me.getKey();
				final Object value = me.getValue();
				final Block kvb = new Infix( layout( key ), "==>", layout( value ) );
				t.add( it.hasNext() ? new Suffix( kvb, "," ) : (Block)kvb );
			}
			s.add(  new StringBlock( "%}" ) );
			return s;
		} else if ( x instanceof XmlElement ) {
			return layoutXmlElement( (XmlElement)x );
		} else if ( x instanceof Map.Entry ) {
			final Map.Entry me = (Map.Entry)x;
			return new Infix( layout( me.getKey() ), "==>", layout( me.getValue() ) );
		} else {
			return new StringBlock( PrintTools.printToString( x ) );
		}
	}

	public void invoke( final Object x ) {
		final Block b = layout( x ).tryToCompact( STANDARD_WIDTH );
		b.prettyPrint( StdOutConsumer.OUT, 0, "" );
	}

	public static final PrettyPrint PRETTY_PRINT_PROC = new PrettyPrint(); 

}
