﻿/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwt.events.TreeListener;

import dwt.dwthelper.utils;


import dwt.events.TreeEvent;
import dwt.internal.SWTEventListener;

/**
 * Classes which implement this interface provide methods
 * that deal with the expanding and collapsing of tree
 * branches.
 * <p>
 * After creating an instance of a class that implements
 * this interface it can be added to a tree control using the
 * <code>addTreeListener</code> method and removed using
 * the <code>removeTreeListener</code> method. When a branch
 * of the tree is expanded or collapsed, the appropriate method
 * will be invoked.
 * </p>
 *
 * @see TreeAdapter
 * @see TreeEvent
 */
public interface TreeListener : SWTEventListener {

/**
 * Sent when a tree branch is collapsed.
 *
 * @param e an event containing information about the tree operation
 */
public void treeCollapsed(TreeEvent e);

/**
 * Sent when a tree branch is expanded.
 *
 * @param e an event containing information about the tree operation
 */
public void treeExpanded(TreeEvent e);
}
