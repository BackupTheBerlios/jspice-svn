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

package org.openspice.jspice.lexis;

import org.openspice.jspice.tokens.Token;
import org.openspice.jspice.tokens.NameToken;
import org.openspice.jspice.tokens.QuotedToken;
import org.openspice.jspice.tokens.NumberToken;

import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.main.Interpreter;
import org.openspice.jspice.tools.StyleWarning;
import org.openspice.jspice.conf.DynamicConf;
import org.openspice.tools.AbsIteratorOfChar;
import org.openspice.tools.IteratorOfChar;

import java.io.*;
import java.util.Map;
import java.util.HashMap;
import java.util.TreeMap;
import java.util.regex.Pattern;

import org.openspice.jspice.main.Pragma;

abstract class TokenizerImplMixinBuffer extends ParseEscape {

	private final StringBuffer buffer = new StringBuffer();
	private final StringBuffer token_text = new StringBuffer();

	protected TokenizerImplMixinBuffer( final DynamicConf jspice_conf ) {
		super( jspice_conf );
	}

	protected void clear() {
		this.token_text.setLength( 0 );
		this.buffer.setLength( 0 );
	}

	protected boolean bufferEquals( final char c ) {
		return this.buffer.length() == 1 && this.buffer.charAt( 0 ) == c;
	}

	protected int bufferLength() {
		return this.buffer.length();
	}

	protected IteratorOfChar bufferIteratorOfChar() {
		return(
			new AbsIteratorOfChar() {
				int n = 0;
				final StringBuffer buff = TokenizerImplMixinBuffer.this.buffer;

				public boolean hasNext() {
					return this.buff.length() < n;
				}

				public char nextChar() {
					return this.buff.charAt( this.n++ );
				}
			}
		);
	}

	protected int tokenTextLength() {
		return this.buffer.length();
	}

	protected void bufferAppend( final char ch, final boolean and_buff ) {
		this.token_text.append( ch );
		if ( and_buff ) this.buffer.append( ch );
	}

//	private void bufferAppend( final String s, final boolean and_buff ) {
//		this.token_text.append( s );
//		if ( and_buff ) this.buffer.append( s );
//	}

	//	  Support function for cantStick
    protected char lastCharInBuff() {
        return this.buffer.charAt( this.buffer.length() - 1 );
    }

	protected String fetchBuffer() {
		return this.buffer.toString();
	}

	protected String fetchTokenText() {
		return this.token_text.toString();
	}

}

abstract class TokenizerImplMixinFlags extends TokenizerImplMixinBuffer {

	private int mask = 0;

	protected TokenizerImplMixinFlags( final DynamicConf jspice_conf ) {
		super( jspice_conf );
	}

	public int getMask() {
		return this.mask;
	}

	public void setMask( final int mask ) {
		this.mask = mask;
	}

	public void clear() {
		super.clear();
		this.mask = 0;
	}

}

class TokenizerImpl extends TokenizerImplMixinFlags implements Tokenizer {
    private final Source source;
	private final Interpreter interpreter;
	private Map< Integer, CharSequence > interpolation_map = new HashMap< Integer, CharSequence >();

    TokenizerImpl( final Interpreter interpreter, final String _printName, final Reader _reader, final String _prompt ) {
		super( interpreter.getDynamicConf() );
		this.interpreter = interpreter;
        this.source = new Source( _printName, _reader, _prompt );
    }

	public void clear() {
		super.clear();
		this.interpolation_map.clear();
	}

	private void addInterpolation( final CharSequence cs ) {
		this.interpolation_map.put( new Integer( this.bufferLength() ), cs );
	}

	private Map optInterpolationMap() {
		if ( interpolation_map.isEmpty() ) return null;
		return new TreeMap< Integer, CharSequence >( this.interpolation_map );
	}

	public void dropChar() {
		this.source.readInt();
	}

	public char readChar( final char default_char ) {
		return this.source.readChar( default_char );
	}

	public char readCharNoEOF() {
		return this.source.readCharNoEOF();
	}

	private int readInt() {
		return this.source.readInt();
	}
	
	private void pushInt( final int ich ) {
		this.source.pushInt( ich );
	}

    public String getPrintName() {
        return this.source.getPrintName();
    }

    public int getLineNumber() {
        //	  Adjust for 0-indexing.
        return this.source.getLineNumber() + 1;
    }

	public final Alert alert( final String msg1, final String msg2 ) {
		final Alert a = new Alert( msg1, msg2, 'T' );
        a.culprit( "file", this.getPrintName() );
        a.culprit( "line no.", new Integer( this.getLineNumber() ) );
		return a;
	}

    private void addChar( final int ich, final boolean and_buff ) {
        this.bufferAppend( (char)ich, and_buff );
    }

	private char okChar( final int ich, final char default_char, final boolean and_buff ) {
		this.addChar( ich, and_buff );
		return this.readChar( default_char );
	}

	private char peekChar( final char default_char ) {
		final int ch = this.source.readInt();
		this.source.pushInt( ch );
		return ch == -1 ? default_char : (char)ch;
	}

	private char okCharNoEOF( final int ich, final boolean and_buff ) {
		this.addChar( ich, and_buff );
		return this.readCharNoEOF();
	}


    private static boolean isSign( final char ch ) {
        return "<>!$%^&*-+=|:?/~".indexOf( ch ) >= 0;
    }

    //	  Required to support the tokenization bodge for REXML i.e.
    //	  to unstick sequences such as "></" into ">" and "</"
    private boolean cantStick( final char ch ) {
		return(
			ch == '<' && this.lastCharInBuff() == '>' ||
			ch == '>' && this.lastCharInBuff() == '<'
		);
    }

	private void readRepetitions( final int orig, final boolean and_buff ) {
		int ich = orig;
		do {
			ich = this.okChar( ich, ' ', and_buff );
		} while ( orig == ich );
		this.source.pushInt( ich );
	}
	
	public static final Map< Character, Integer > REGEX_FLAGS = new HashMap< Character, Integer >();
	{
		REGEX_FLAGS.put( new Character( 'u' ), new Integer( Pattern.UNICODE_CASE ) );
		REGEX_FLAGS.put( new Character( 'i' ), new Integer( Pattern.CASE_INSENSITIVE ) );
		REGEX_FLAGS.put( new Character( 'x' ), new Integer( Pattern.COMMENTS ) );
		REGEX_FLAGS.put( new Character( 'd' ), new Integer( Pattern.UNIX_LINES ) );
		REGEX_FLAGS.put( new Character( 'm' ), new Integer( Pattern.MULTILINE ) );
		REGEX_FLAGS.put( new Character( 's' ), new Integer( Pattern.DOTALL ) );
	}

	private void parseString( final char end_char, final Map flags ) {
		char ch = this.readCharNoEOF();   //okChar( endChar );
		while ( ch != end_char ) {
			if ( ch == '\r' || ch == '\n' ) {
				new Alert( "Unterminated string",
					"A newline or carriage return was encountered before the closing quotes" ).
					culprit( "partial string", this.fetchTokenText() ).
					mishap( 'T' );
			} else if ( ch == '\\' ) {
				try {
					ch = this.okCharNoEOF( this.parseEscape(), true );
				} catch ( ParseEscapeException e ) {
					final CharSequence cs = e.getValue();
					this.addInterpolation( cs );
					ch = this.readCharNoEOF();
				}
			} else {
				ch = this.okCharNoEOF( ch, true );
			}
		}
		this.addChar( end_char, false );
		if ( flags != null ) {
			int mask = 0;
			for (;;) {
				final char c = this.peekChar( ' ' );
				final Integer k = (Integer)flags.get( new Character( c ) );
				if ( k == null ) break;
				this.dropChar();
				mask |= k.intValue();
			}
			this.setMask( mask );
		}
	}

	private Token makeNameToken( final boolean hadWhite ) {
		return new NameToken( hadWhite, this.fetchBuffer() );
	}

	private Token readStringToken( final boolean hadWhite, final char ch, final Map flags ) {
		this.parseString( ch, flags );
		final String s = this.fetchBuffer();
		if ( ch == '\'' && s.length() != 1 ) {
			StyleWarning.one_char_literal( s );
		}
		return new QuotedToken( hadWhite, s, ch, this.optInterpolationMap(), this.getMask() );
	}

	private Token makeIntToken( final boolean hadWhite ) {
		try {
			return new NumberToken( hadWhite, this.fetchBuffer() );
		} catch ( NumberFormatException ex ) {
			this.alert( "Cannot internalize this number" ).culprit( "number", this.fetchTokenText() ).mishap();
		}
		return null;
	}

	public Token readToken() {
		return this.readToken( false );
	}

	/**
	 * Nested comments.  You enter here having read # and the start_char.
	 * You return after having read the corresponding stop-char.
	 */
	private void readNestedCommentTo( final char start_char, final char stop_char ) {
		char ch = this.readCharNoEOF();
		char nch;
		int level = 1;
		for (;;) {
			if ( ch == '#' ) {
				nch = this.readCharNoEOF();
				if ( nch == stop_char ) {
					level -= 1;
					if ( level == 0 ) return;
					ch = this.readCharNoEOF();
				} else if ( nch == start_char ) {
					level += 1;
					ch = this.readCharNoEOF();
				} else {
					ch = nch;
				}
			} else {
				ch = this.readCharNoEOF();
			}
		}
	}

	private String readToEndOfLine( int ch ) {
		final StringBuffer b = new StringBuffer();
		while ( ch != '\n' && ch != -1 ) {
			b.append( (char)ch );
			ch = this.readCharNoEOF();
		}
		return b.toString();
	}

	private void readPragma( final String string ) {
		new Pragma( this.interpreter, string ).perform();
	}

	private void readComment() {
		int ch;
		//	  Dispose of a sequence of comments.
		do {
			ch = this.readCharNoEOF();
			switch ( ch ) {
				case ' ':
				case '\t':
				case '#':
				case '\r':
				case '\n':
					while ( ch != '\n' ) {
						ch = this.readCharNoEOF();
					}
					break;
				case '(':
					this.readNestedCommentTo( '(', ')' );
					break;
				case '[':
					this.readNestedCommentTo( '[', ']' );
					break;
				case '{':
					this.readNestedCommentTo( '{', '}' );
					break;
				case '<':
					this.readNestedCommentTo( '<', '>' );
					break;
				default:
					this.readPragma( this.readToEndOfLine( ch ) );
					break;
			}

			//	Eat any white space before checking whether to continue.
			do {
				ch = this.readInt();
			} while ( ch != -1 && Character.isWhitespace( (char)ch ) );
		} while ( ch == '#' );
		this.pushInt( ch );
	}

	private Token readToken( boolean hadWhiteAtStart ) {
		this.clear();
		int ch = this.readInt();
		while ( ch != -1 && Character.isWhitespace( (char)ch ) ) {
			hadWhiteAtStart = true;
			ch = this.readInt();
		}
		if ( ch == -1 ) {
			return null;						//	 end of file.
		} else if ( ch == '#' ) {
			hadWhiteAtStart = true;
			this.readComment();
			//	Recurse.
			return this.readToken( hadWhiteAtStart );
		} else if ( Character.isLetter( (char)ch ) ) {
			ch = this.okChar( ch, ' ', true );
			while ( Character.isLetterOrDigit( (char)ch ) || ch == '_' ) {
				ch = this.okChar( ch, ' ', true );
			}
			this.source.pushInt( ch );
			return this.makeNameToken( hadWhiteAtStart );
		} else if ( Character.isDigit( (char)ch ) || ch == '-' && Character.isDigit( this.peekChar( ' ' ) ) ) {
			ch = this.okChar( ch, ' ', true );
			while ( Character.isDigit( (char)ch ) ) {
				ch = this.okChar( ch, ' ', true );
			}
			if ( ch == '.' && Character.isDigit( this.peekChar( ' ' ) ) ) {
				ch = this.okChar( ch, ' ', true );
				while ( Character.isDigit( (char)ch ) ) {
					ch = this.okChar( ch, ' ', true );
				}
				this.pushInt( ch );
			} else {
				this.pushInt( ch );
			}
			if ( this.bufferEquals( '-' ) ) {
				return this.makeNameToken( hadWhiteAtStart );
			} else {
				return this.makeIntToken( hadWhiteAtStart );
			}
		} else if ( ch == '"' || ch == '\'' || ch == '`' || ch == '/' && this.source.tryRead( "/" ) ) {
			this.addChar( ch, false );
			if ( ch == '/' ) this.addChar( ch, false );
			return this.readStringToken( hadWhiteAtStart, (char)ch, ch == '/' ? REGEX_FLAGS : null );
		} else if ( ch == '.' || ch == '@' || ch == '?' ) {
			this.readRepetitions( ch, true );
			return this.makeNameToken( hadWhiteAtStart );
		} else if ( isSign( (char)ch ) ) {
			ch = this.okChar( ch, ' ', true );
			while ( isSign( (char)ch ) && !( this.cantStick( (char)ch ) ) ) {
				ch = this.okChar( ch, ' ', true );
			}
			this.source.pushInt( ch );
			return this.makeNameToken( hadWhiteAtStart );
		} else {
			//	Yuck.  Not at all sure this is correct.
			this.addChar( ch, true );
			return this.makeNameToken( hadWhiteAtStart );
		}
	}

    public String getTagName() {
		for ( IteratorOfChar it = this.bufferIteratorOfChar(); it.hasNext(); ) {
			final char ch = it.nextChar();
            if ( ! (
                Character.isLetterOrDigit( ch ) ||
                "_:-".indexOf( ch ) >= 0
            ) ) {
                this.alert( "Invalid tag name" ).culprit( "name", this.fetchTokenText() ).mishap();
            }
        }
        return this.fetchBuffer();
    }

}




