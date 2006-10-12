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
//import org.openspice.jspice.datatypes.Arity;
//
//public class ApplyCodeList extends CodeList {
//
//	private final ProcFactory procFactory;
//
//	private Arity in_arity;
//	private Arity out_arity;
//
//	public ApplyCodeList( ProcFactory procFactory ) {
//		this.procFactory = procFactory;
//	}
//
//	public ApplyCodeList( ProcFactory procFactory, Arity in_arity, Arity out_arity ) {
//		this.procFactory = procFactory;
//		this.in_arity = in_arity;
//		this.out_arity = out_arity;
//	}
//
//	public Arity getInArity() {
//		return in_arity;
//	}
//
//	public void setInArity( Arity in_arity ) {
//		this.in_arity = in_arity;
//	}
//
//	public Arity getOutArity() {
//		return out_arity;
//	}
//
//	public void setOutArity( Arity out_arity ) {
//		this.out_arity = out_arity;
//	}
//
//	public boolean isReady() {
//		return in_arity != null && out_arity != null;
//	}
//
//}
