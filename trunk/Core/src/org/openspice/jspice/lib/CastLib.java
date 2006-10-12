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


package org.openspice.jspice.lib;
import org.openspice.jspice.alert.Alert;
import org.openspice.jspice.datatypes.proc.Proc;
import org.openspice.jspice.datatypes.proc.Unary1FastProc;
import org.openspice.jspice.datatypes.Deferred;
import org.openspice.jspice.datatypes.SpiceClass;
import org.openspice.jspice.datatypes.Symbol;
import org.openspice.jspice.datatypes.SpiceObject;
import org.openspice.jspice.datatypes.regexs.Binding;
import org.openspice.jspice.datatypes.elements.XmlElement;
import org.openspice.jspice.tools.Consumer;
import org.openspice.jspice.vm_and_compiler.VM;

import java.util.*;
import java.util.List;
import java.util.regex.Pattern;
import java.awt.*;

public class CastLib {

	private static RuntimeException oops( final Exception ex, final String msg, final Object obj ) {
		return new Alert( ex, msg ).culprit( "item", obj ).mishap();
	}

	private static RuntimeException oops( final String msg, final Object obj ) {
		return new Alert( msg ).culprit( "item", obj ).mishap();
	}

	public static boolean to_boolean( final Object obj ) {
		return toBoolean( obj ).booleanValue();
	}

	public static Binding toBinding( final Object obj ) {
		try {
			if ( obj != null ) return (Binding)obj;
			throw oops( "Binding needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toBinding( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Binding needed", obj );
			}
		}
	}

	public static Boolean toBoolean( final Object obj ) {
		try {
			if ( obj != null ) return (Boolean)obj;
			throw oops( "Boolean needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toBoolean( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Boolean needed", obj );
			}
		}
	}

	public static Character toCharacter( final Object obj ) {
		try {
			if ( obj != null ) return (Character)obj;
			throw oops( "Character needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toCharacter( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Character needed", obj );
			}
		}
	}

	public static CharSequence toCharSequence( final Object obj ) {
		try {
			if ( obj != null ) return (CharSequence)obj;
			throw oops( "CharSequence needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toCharSequence( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "CharSequence needed", obj );
			}
		}
	}

	public static Pattern toPattern( final Object obj ) {
		try {
			if ( obj != null ) return (Pattern)obj;
			throw oops( "Pattern needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toPattern( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Pattern needed", obj );
			}
		}
	}


	public static Class toClass( final Object obj ) {
		try {
			if ( obj != null ) return (Class)obj;
			throw oops( "Class needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toClass( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Class needed", obj );
			}
		}
	}

	public static Integer toInteger( final Object obj ) {
		try {
			if ( obj != null ) return (Integer)obj;
			throw oops( "Integer needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toInteger( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Integer needed", obj );
			}
		}
	}

	public static final int to_int( final Object obj ) {
		return toInteger( obj ).intValue();
	}

	public static List toList( final Object obj ) {
		try {
			if ( obj != null ) return (List)obj;
			throw oops( "List needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toList( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "List needed", obj );
			}
		}
	}

	public static Map toMap( final Object obj ) {
		try {
			if ( obj != null ) return (Map)obj;
			throw oops( "Map needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toMap( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Map needed", obj );
			}
		}
	}

	public static Map.Entry toMaplet( final Object obj ) {
		try {
			if ( obj != null ) return (Map.Entry)obj;
			throw oops( "Maplet needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toMaplet( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Maplet needed", obj );
			}
		}
	}

	public static Number toNumber( final Object obj ) {
		try {
			if ( obj != null ) return (Number)obj;
			throw oops( "Number needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toNumber( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Number needed", obj );
			}
		}
	}



//	public static Proc toProc( final Object obj ) {
//		try {
//			if ( obj != null ) return (Proc)obj;
//			throw oops( "Proc needed", obj );
//		} catch ( final ClassCastException _ ) {
//			try {
//				return toProc( ((Deferred)obj).get() );
//			} catch ( final ClassCastException exn ) {
//				throw oops( exn, "Proc needed", obj );
//			}
//		}
//	}

	public static Proc toProc( final Object obj ) {
		try {
			if ( obj != null ) return (Proc)obj;
		} catch ( final ClassCastException _ ) {
		}
		if ( obj == null ) {
			throw new Alert( "Trying to apply absent" ).mishap();
		} else {
			if ( obj instanceof List ) {
				return (
					new Unary1FastProc() {
						public Object fastCall( Object tos, VM vm, int nargs ) {
							return ((List)obj).get( CastLib.to_int( tos ) - 1 );
						}
					}
				);
			} else if ( obj instanceof CharSequence ) {
				return(
					new Unary1FastProc() {
						public Object fastCall( Object tos, VM vm, int nargs ) {
							return new Character( ((CharSequence)obj).charAt( CastLib.to_int( tos ) - 1 ) );
						}
					}
				);
			} else if ( obj instanceof Map ) {
				return(
					new Unary1FastProc() {
						public Object fastCall( Object tos, VM vm, int nargs ) {
							return ((Map)obj).get( Deferred.deref( tos ) );
						}
					}
				);
			} else if ( obj instanceof SpiceObject ) {
				return ((SpiceObject)obj).asProc();
			} else if ( obj instanceof Pattern ) {
				return (
					new Unary1FastProc() {
						public Object fastCall( Object tos, VM vm, int nargs ) {
							return Boolean.valueOf( ((Pattern)obj).matcher( CastLib.toCharSequence( tos ) ).find() );
						}
					}
				);
			} else {
				throw new Alert( "Don't know how to apply this object" ).culprit( "object", obj ).mishap();
			}
		}
	}

	public static SpiceClass toSpiceClass( final Object obj ) {
		try {
			if ( obj != null ) return (SpiceClass)obj;
			throw oops( "SpiceClass needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toSpiceClass( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Class needed", obj );
			}
		}
	}



	public static final String toString( final Object obj ) {
		try {
			if ( obj != null ) return (String)obj;
			throw oops( "String needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toString( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "String needed", obj );
			}
		}
	}

	public static final Symbol toSymbol( final Object obj ) {
		try {
			if ( obj != null ) return (Symbol)obj;
			throw oops( "AltSymbol needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toSymbol( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "AltSymbol needed", obj );
			}
		}
	}

	public static final XmlElement toXmlElement( final Object obj ) {
		try {
			if ( obj != null ) return (XmlElement)obj;
			throw oops( "XmlElement needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toXmlElement( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "XmlElement needed", obj );
			}
		}
	}


	public static final Image toImage( final Object obj ) {
		try {
			if ( obj != null ) return (Image)obj;
			throw oops( "Image needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toImage( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Image needed", obj );
			}
		}
	}

	public static final Consumer toConsumer( final Object obj ) {
		try {
			if ( obj != null ) return (Consumer)obj;
			throw oops( "Consumer needed", obj );
		} catch ( final ClassCastException _ ) {
			try {
				return toConsumer( ((Deferred)obj).get() );
			} catch ( final ClassCastException exn ) {
				throw oops( exn, "Consumer needed", obj );
			}
		}
	}


}
