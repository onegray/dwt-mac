/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *
 * Port to the D programming language:
 *     Jacob Carlborg <doob@me.com>
 *******************************************************************************/
module dwt.internal.cocoa.SWTTextView;

import dwt.dwthelper.utils;
import dwt.internal.cocoa.NSTextView;
import objc = dwt.internal.objc.runtime;

public class SWTTextView : NSTextView {

public this() {
    super(cast(objc.id) null);
}

public this(objc.id id) {
    super(id);
}

}
