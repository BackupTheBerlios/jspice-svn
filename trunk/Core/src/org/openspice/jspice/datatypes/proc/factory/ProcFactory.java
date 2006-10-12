///**
// *	JSpice, an Open Spice interpreter and library.
// *	Copyright (C) 2005, Stephen F. K. Leach
// *
// * 	This program is free software; you can redistribute it and/or modify
// *	it under the terms of the GNU General Public License as published by
// * 	the Free Software Foundation; either version 2 of the License, or
// * 	(at your option) any later version.
// *
// * 	This program is distributed in the hope that it will be useful,
// * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
// * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// *	GNU General Public License for more details.
// *
// *	You should have received a copy of the GNU General Public License
// * 	along with this program; if not, write to the Free Software
// *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// */
//package org.openspice.jspice.datatypes.proc.factory;
//
//import org.openspice.jspice.datatypes.proc.Proc;
//import org.openspice.jspice.datatypes.proc.Description;
//import org.openspice.jspice.class_builder.JSpiceClassLoader;
//import org.openspice.jspice.class_builder.ClassBuilder;
//import org.openspice.jspice.class_builder.NameGenerator;
//import org.openspice.jspice.conf.DynamicConf;
//import org.openspice.jspice.conf.StaticConf;
//
//public class ProcFactory {
//
//	final private DynamicConf jspice_conf;
//	private Description description;
//	private Proc inverse;
//
//
//	public ProcFactory( final DynamicConf jspice_conf, final Description description ) {
//		this.jspice_conf = jspice_conf;
//		this.description = description;
//	}
//
//	public ApplyCodeList newApplyFactory() {
//		return new ApplyCodeList( this );
//	}
//
//	public UpdateCodeList newUpdateFactory() {
//		return new UpdateCodeList( this );
//	}
//
//	public Proc getInverse() {
//		return inverse;
//	}
//
//	public void setInverse( Proc inverse ) {
//		this.inverse = inverse;
//	}
//
//	public DynamicConf getJSpiceConf() {
//		return this.jspice_conf;
//	}
//
//	public Description getDescription() {
//		return this.description;
//	}
//
//}
