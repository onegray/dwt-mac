﻿/*******************************************************************************
 * Copyright (c) 2000, 2009 IBM Corporation and others.
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
module dwt.widgets.TabItem;

import dwt.dwthelper.utils;






import dwt.DWT;
import dwt.internal.cocoa.NSView;
import dwt.internal.cocoa.NSValue;
import dwt.internal.cocoa.NSPoint;
import dwt.internal.cocoa.NSSize;
import dwt.internal.cocoa.NSWindow;
import dwt.internal.cocoa.NSString;
import dwt.internal.cocoa.NSTabViewItem;
import dwt.internal.cocoa.OS;
import dwt.internal.objc.cocoa.Cocoa;
import objc = dwt.internal.objc.runtime;
import dwt.widgets.Control;
import dwt.widgets.Item;
import dwt.widgets.TabFolder;
import dwt.graphics.Image;
import dwt.graphics.Rectangle;

/**
 * Instances of this class represent a selectable user interface object
 * corresponding to a tab for a page in a tab folder.
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>(none)</dd>
 * <dt><b>Events:</b></dt>
 * <dd>(none)</dd>
 * </dl>
 * <p>
 * IMPORTANT: This class is <em>not</em> intended to be subclassed.
 * </p>
 *
 * @see <a href="http://www.eclipse.org/swt/snippets/#tabfolder">TabFolder, TabItem snippets</a>
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 * @noextend This class is not intended to be subclassed by clients.
 */
public class TabItem : Item {
    TabFolder parent;
    Control control;
    String toolTipText;
    NSTabViewItem nsItem;

/**
 * Constructs a new instance of this class given its parent
 * (which must be a <code>TabFolder</code>) and a style value
 * describing its behavior and appearance. The item is added
 * to the end of the items maintained by its parent.
 * <p>
 * The style value is either one of the style constants defined in
 * class <code>DWT</code> which is applicable to instances of this
 * class, or must be built by <em>bitwise OR</em>'ing together
 * (that is, using the <code>int</code> "|" operator) two or more
 * of those <code>DWT</code> style constants. The class description
 * lists the style constants that are applicable to the class.
 * Style bits are also inherited from superclasses.
 * </p>
 *
 * @param parent a composite control which will be the parent of the new instance (cannot be null)
 * @param style the style of control to construct
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the parent is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the parent</li>
 *    <li>ERROR_INVALID_SUBCLASS - if this class is not an allowed subclass</li>
 * </ul>
 *
 * @see DWT
 * @see Widget#checkSubclass
 * @see Widget#getStyle
 */
public this (TabFolder parent, int style) {
    super (parent, style);
    this.parent = parent;
    parent.createItem (this, parent.getItemCount ());
}

/**
 * Constructs a new instance of this class given its parent
 * (which must be a <code>TabFolder</code>), a style value
 * describing its behavior and appearance, and the index
 * at which to place it in the items maintained by its parent.
 * <p>
 * The style value is either one of the style constants defined in
 * class <code>DWT</code> which is applicable to instances of this
 * class, or must be built by <em>bitwise OR</em>'ing together
 * (that is, using the <code>int</code> "|" operator) two or more
 * of those <code>DWT</code> style constants. The class description
 * lists the style constants that are applicable to the class.
 * Style bits are also inherited from superclasses.
 * </p>
 *
 * @param parent a composite control which will be the parent of the new instance (cannot be null)
 * @param style the style of control to construct
 * @param index the zero-relative index to store the receiver in its parent
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the parent is null</li>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the parent (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the parent</li>
 *    <li>ERROR_INVALID_SUBCLASS - if this class is not an allowed subclass</li>
 * </ul>
 *
 * @see DWT
 * @see Widget#checkSubclass
 * @see Widget#getStyle
 */
public this (TabFolder parent, int style, int index) {
    super (parent, style);
    this.parent = parent;
    parent.createItem (this, index);
}

protected void checkSubclass () {
    if (!isValidSubclass ()) error (DWT.ERROR_INVALID_SUBCLASS);
}

void destroyWidget () {
    parent.destroyItem (this);
    releaseHandle ();
}

/**
 * Returns a rectangle describing the receiver's size and location
 * relative to its parent.
 *
 * @return the receiver's bounding rectangle
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.4
 */
public Rectangle getBounds() {
    checkWidget();
    Rectangle result = new Rectangle (0, 0, 0, 0);
    if (nsItem.respondsToSelector (OS.sel_accessibilityAttributeValue_)) {
        objc.id posValue = OS.objc_msgSend (nsItem.id, OS.sel_accessibilityAttributeValue_, OS.NSAccessibilityPositionAttribute_);
        objc.id sizeValue = OS.objc_msgSend (nsItem.id, OS.sel_accessibilityAttributeValue_, OS.NSAccessibilitySizeAttribute_);
        NSValue val = new NSValue (posValue);
        NSPoint pt = val.pointValue ();
        NSWindow window = parent.view.window ();
        pt.y = display.getPrimaryFrame().height - pt.y;
        pt = parent.view.convertPoint_fromView_ (pt, null);
        pt = window.convertScreenToBase (pt);
        result.x = cast(int) pt.x;
        result.y = cast(int) pt.y;
        val = new NSValue (sizeValue);
        NSSize size = val.sizeValue ();
        result.width = cast(int) Math.ceil (size.width);
        result.height = cast(int) Math.ceil (size.height);
    }
    return result;
}

/**
 * Returns the control that is used to fill the client area of
 * the tab folder when the user selects the tab item.  If no
 * control has been set, return <code>null</code>.
 * <p>
 * @return the control
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public Control getControl () {
    checkWidget ();
    return control;
}

/**
 * Returns the receiver's parent, which must be a <code>TabFolder</code>.
 *
 * @return the receiver's parent
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public TabFolder getParent () {
    checkWidget ();
    return parent;
}

/**
 * Returns the receiver's tool tip text, or null if it has
 * not been set.
 *
 * @return the receiver's tool tip text
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public String getToolTipText () {
    checkWidget ();
    return toolTipText;
}

void releaseHandle () {
    super.releaseHandle ();
    if (nsItem !is null) nsItem.release();
    nsItem = null;
    parent = null;
}

void releaseParent () {
    super.releaseParent ();
    int index = parent.indexOf (this);
    if (index is parent.getSelectionIndex ()) {
        if (control !is null) control.setVisible (false);
    }
}

void releaseWidget () {
    super.releaseWidget ();
    control = null;
}

/**
 * Sets the control that is used to fill the client area of
 * the tab folder when the user selects the tab item.
 * <p>
 * @param control the new control (or null)
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_ARGUMENT - if the control has been disposed</li>
 *    <li>ERROR_INVALID_PARENT - if the control is not in the same widget tree</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setControl (Control control) {
    checkWidget ();
    if (control !is null) {
        if (control.isDisposed()) error (DWT.ERROR_INVALID_ARGUMENT);
        if (control.parent !is parent) error (DWT.ERROR_INVALID_PARENT);
    }
    if (this.control !is null && this.control.isDisposed ()) {
        this.control = null;
    }
    Control oldControl = this.control, newControl = control;
    this.control = control;
    int index = parent.indexOf (this), selectionIndex = parent.getSelectionIndex();;
    if (index !is selectionIndex) {
        if (newControl !is null) {
            bool hideControl = true;
            if (selectionIndex !is -1) {
                Control selectedControl = parent.getItem(selectionIndex).getControl();
                if (selectedControl is newControl) hideControl=false;
            }
            if (hideControl) newControl.setVisible(false);
        }
    } else {
        if (newControl !is null) {
            newControl.setVisible (true);
        }
        if (oldControl !is null) oldControl.setVisible (false);
    }
    NSView view;
    if (newControl !is null) {
        view = newControl.topView();
    } else {
        view = cast(NSView)(new NSView()).alloc();
        view.init ();
        view.autorelease();
    }
    nsItem.setView (view);
    /*
    * Feature in Cocoa.  The method setView() removes the old view from
    * its parent.  The fix is to detected it has been removed and add
    * it back.
    */
    if (oldControl !is null) {
        NSView topView = oldControl.topView ();
        if (topView.superview () is null) {
            parent.contentView ().addSubview (topView, OS.NSWindowBelow, null);
        }
    }
}

public void setImage (Image image) {
    checkWidget ();
    int index = parent.indexOf (this);
    if (index is -1) return;
    super.setImage (image);
}

/**
 * Sets the receiver's text.  The string may include
 * the mnemonic character.
 * </p>
 * <p>
 * Mnemonics are indicated by an '&amp;' that causes the next
 * character to be the mnemonic.  When the user presses a
 * key sequence that matches the mnemonic, a selection
 * event occurs. On most platforms, the mnemonic appears
 * underlined but may be emphasised in a platform specific
 * manner.  The mnemonic indicator character '&amp;' can be
 * escaped by doubling it in the string, causing a single
 * '&amp;' to be displayed.
 * </p>
 *
 * @param string the new text
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the text is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 */
public void setText (String string) {
    checkWidget ();
    // DWT extension: allow null for zero length string
    //if (string is null) error (DWT.ERROR_NULL_ARGUMENT);
    int index = parent.indexOf (this);
    if (index is -1) return;
    super.setText (string);
    char [] chars = new char [string.length];
    string.getChars (0, chars.length, chars, 0);
    int length = fixMnemonic (chars);
    NSString str = NSString.stringWithCharacters (chars.toString16().ptr, length);
    nsItem.setLabel (str);
}

/**
 * Sets the receiver's tool tip text to the argument, which
 * may be null indicating that the default tool tip for the
 * control will be shown. For a control that has a default
 * tool tip, such as the Tree control on Windows, setting
 * the tool tip text to an empty string replaces the default,
 * causing no tool tip text to be shown.
 * <p>
 * The mnemonic indicator (character '&amp;') is not displayed in a tool tip.
 * To display a single '&amp;' in the tool tip, the character '&amp;' can be
 * escaped by doubling it in the string.
 * </p>
 *
 * @param string the new tool tip text (or null)
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setToolTipText (String string) {
    checkWidget();
    toolTipText = string;
    parent.checkToolTip (this);
}

String tooltipText () {
    return toolTipText;
}

void update () {
    setText (text);
    setImage (image);
    setToolTipText (toolTipText);
}

}
