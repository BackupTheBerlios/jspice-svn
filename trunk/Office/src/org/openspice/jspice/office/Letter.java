/**
 *	JSpice, an Open Spice interpreter and library.
 *	Copyright (C) 2005, Stephen F. K. Leach
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
package org.openspice.jspice.office;

import java.util.*;
import java.lang.reflect.Method;

/**
 * <p>
 * A Letter is an atomic communication.  It has
 * <ol>
 * <li> a sender, an ({@link Tray}), optionally null
 * <li> a recipient, an {@link Tray}),  optionally null
 * <li> a subject, which is typically a String, and
 * <li> content which is discussed in more detail below.
 * </ol>
 *
 * <p>
 * Formally speaking the sender and recipients are identified by Trays.
 * More commonly, we tend to think of them as being the {@link Worker}s that
 * own the {@link Trays but since it is possible to have an Tray without
 * a Worker, that isn't strictly right.
 *
 * <p>
 * The sender may be null, indicating
 * that the message does not need any reply - typical for an initialization
 * message.  Less usefully, the recipient may be null, perhaps because it
 * is to be sent to several Workers.  In this case, the programmer should
 * take care to use the {@link InTray#sendOne} method to explicitly send
 * the message.
 *
 * <p>
 * The subject is typically a {@link String} or a {@link Method}.  The
 * principal role of the subject is to allow Workers to quickly determine
 * the correct course of action.  For that reason, if the subject is a
 * String it is guaranteed to be interned.
 *
 * <p>
 * The content of a Letter is simultaneously like a {@link List} and a {@link Map}.
 * You can create and retrieve the List-like content using {@link #add} and {@link #get(int)}.
 * And you can create and retrieve the
 * Map-like content with {@link #put(Object, Object)} and {@link #get(Object)}.
 *
 * <p>
 *
 */
public class Letter implements LetterIntf {

	protected Tray from;
	protected Tray to;
	protected Object subject;

	private static final Set validClasses = new HashSet();

	private static Object checkValidSubject( final Object subject ) {
		if ( subject instanceof String ) return ((String)subject).intern();
		if ( subject instanceof Method ) return subject;
		for ( Iterator it = validClasses.iterator(); it.hasNext(); ) {
			final Class vc = (Class)it.next();
			if( vc.isInstance( subject ) ) return subject;
		}
		throw new RuntimeException( "Unacceptable type for subject: " + subject );
	}

	public Letter( final Tray from, final Tray to, final Object subject ) {
		this.from = from;
		this.to = to;
		this.subject = checkValidSubject( subject );
	}

	/**
	 * Returns the {@link Tray} which is marked as the originator of
	 * the message.  May be null.
	 * @return the originating {@link Tray}
	 */
	public Tray getFrom() {
		return this.from;
	}

	/**
	 * Sets the {@link Tray} which is the originator of
	 * the message.  May be null.
	 */
	public void setFrom( final Tray from ) {
		this.from = from;
	}

	/**
	 * Returns the {@link Tray} which is marked as the recipient of
	 * the message.  May be null in unusual circumstances.
	 * @return the recipient {@link Tray}
	 */
	public Tray getTo() {
		return this.to;
	}

	private Tray doGetTo() {
		if ( this.to == null ) throw new RuntimeException( "The recipient is not defined" );
		return this.to;
	}

	/**
	 * Sets the {@link Tray} which is the recipient of
	 * the message.  May be null in unusual circumstances.
	 * @param to recipient of the letter
	 */
	public void setTo( Tray to ) {
		this.to = to;
	}

	/**
	 * Returns the subject of the Letter.  If this is a String it is guranteed to
	 * be interned i.e can be compared safely using "==" rather than {@link Object#equals}
	 * @return subject of the Letter
	 */
	public Object getSubject() {
		return subject;
	}

	/**
	 * Sets the subject of the Letter.  This should be a {@link String} or a {@link Method}.
	 * @param subject of the letter
	 */
	public void setSubject( final Object subject ) {
		this.subject = subject;
	}

	//	---oooOOOooo---

	private List list = null;
	private Map map = null;

	private List fetchList() {
		if ( this.list != null ) return this.list;
		return this.list = new ArrayList( 1 );
	}

	private Map fetchMap() {
		return this.map = new HashMap();
	}

	/**
	 * Appends an value to the end of the content list.
	 * @param value
	 * @return this, for chained method calls
	 */
	public Letter add( final Object value ) {
		this.fetchList().add( value );
		return this;
	}

	/**
	 * Appends a boolean to the end of the content list.  This will be
	 * superfluous when Java gets autoboxing.
	 * @param value
	 * @return this, for chained method calls.
	 */
	public Letter add( final boolean value ) {
		return this.add( Boolean.valueOf( value ) );
	}

	/**
	 * Appends an int to the end of the content list.  This will be
	 * superfluous when Java gets autoboxing.
	 * @param value
	 * @return this, for chained method calls.
	 */
	public Letter add( final int value ) {
		return this.add( new Integer( value ) );
	}

	/**
	 * Inserts a value against a key in the content map.
	 * @param key
	 * @param value
	 * @return this, for chaining method calls
	 */
	public Letter put( final Object key, final Object value ) {
		this.fetchMap().put( key, value );
		return this;
	}

	/**
	 * Retrieves the initial value of the content list.
	 * Same as get(0).
	 * @return first value
	 */
	public Object get() {
		return this.fetchList().get( 0 );
	}

	/**
	 * Retrieves the initial int of the content list.  Equivalent
	 * to ((Integer)get()).intValue()
	 * @return the intValue of the first value
	 */
	public int getInt() {
		return ((Integer)this.get()).intValue();
	}

	/**
	 * Retrieves the initial boolean of the content list.
	 * Equivalent to ((Boolean)get()).booleanValue()
	 * @return the booleanValue of the first value
	 */
	public boolean getBoolean() {
		return ((Boolean)this.get()).booleanValue();
	}

	/**
	 * Fetches the n-th value from the content list.
	 * @param index the index into the list
	 * @return this, for chaining method calls
	 */
	public Object get( final int index ) {
		return this.fetchList().get( index );
	}

	/**
	 * Fetches the n-th value from the content list which
	 * must be an int.
	 * @param index the index into the list
	 * @return the intValue of the n-th value
	 */
	public int getInt( final int index ) {
		return ((Integer)this.get( index )).intValue();
	}

	/**
	 * Fetches the n-th value from the content list which
	 * must be a boolean.
	 * @param index the index into the list
	 * @return the booleanValue of the n-th value
	 */
	public boolean getBoolean( final int index ) {
		return ((Boolean)this.get( index )).booleanValue();
	}

	/**
	 * Fetches the value associated with the key.
	 * @param key
	 * @return the value
	 */
	public Object get( final Object key ) {
		return this.fetchMap().get( key );
	}

	/**
	 * Fetches the int associated with the key.
	 * @param key
	 * @return the int value
	 */
	public int getInt( final Object key ) {
		return ((Integer)this.fetchMap().get( key )).intValue();
	}

	/**
	 * Fetches the boolean associated with the key
	 * @param key
	 * @return the boolean value.
	 */
	public boolean getBoolean( final Object key ) {
		return ((Boolean)this.fetchMap().get( key )).booleanValue();
	}


	/**
	 * Returns the content list as an array of Objects
	 * @return an array of values
	 */
	public Object[] posnArray() {
//		System.err.println( "fetchList: " + this.fetchList().size() );
		return this.fetchList().toArray();
	}

	/**
	 * Returns the content list as a list.
	 * @return a list of values
	 */
	public List posnList() {
		return this.fetchList();
	}

	/**
	 * Returns the content map as a {@link Map}.
	 * @return a map from keys to values
	 */
	public Map keyedMap() {
		return this.fetchMap();
	}

	/**
	 * Returns the size of the content list.
	 * @return the size 
	 */
	public int posnSize() {
		return this.list == null ? 0 : this.list.size();
	}

	/**
	 * Returns the size of the content map.
	 * @return the size
	 */
	public int keyedSize() {
		return this.map == null ? 0 : this.map.size();
	}

	/**
	 * Sends the Letter to its recipient.  The recipient must be
	 * non-null for this to work otherwise an Exception will be
	 * thrown.
	 */
	public void send() {
		this.doGetTo().sendOne( this );
	}

	//	---- Dismissal ----

	/**
	 * Returns true if this is a special "dismissal" message that
	 * will cause the receiving InTray to close.
	 * @return true if a dismissal Letter
	 */
	public boolean isDismissal() {
		return false;
	}

	/**
	 * The DismissalLetter is a singleton class whose instance is
	 * used to signal the end of inputs.
	 */
	static final class DismissalLetter extends Letter {

		public DismissalLetter( final Tray from, final Tray to, final Object subject ) {
			super( from, to, subject );
		}

		public boolean isDismissal() {
			return true;
		}

	}

	/**
	 * The singleton instance of the DismissalLetter class.
	 */
	public static final DismissalLetter DISMISSAL_LETTER = new DismissalLetter( null, null, "The Dismissal Letter" );

}
