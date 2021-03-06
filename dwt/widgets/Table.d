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
module dwt.widgets.Table;

import dwt.dwthelper.utils;

import tango.text.convert.Format;





import cocoa = dwt.internal.cocoa.id;

import dwt.DWT;
import dwt.dwthelper.utils;
import dwt.dwthelper.System;
import dwt.accessibility.ACC;
import dwt.internal.cocoa.NSArray;
import dwt.internal.cocoa.NSRect;
import dwt.internal.cocoa.NSFont;
import dwt.internal.cocoa.NSSize;
import dwt.internal.cocoa.NSView;
import dwt.internal.cocoa.NSEvent;
import dwt.internal.cocoa.NSString;
import dwt.internal.cocoa.NSPoint;
import dwt.internal.cocoa.NSCell;
import dwt.internal.cocoa.NSImage;
import dwt.internal.cocoa.NSTableView;
import dwt.internal.cocoa.NSIndexSet;
import dwt.internal.cocoa.NSApplication;
import dwt.internal.cocoa.NSTextFieldCell;
import dwt.internal.cocoa.NSAttributedString;
import dwt.internal.cocoa.NSTableHeaderView;
import dwt.internal.cocoa.NSTableColumn;
import dwt.internal.cocoa.NSButtonCell;
import dwt.internal.cocoa.NSScrollView;
import dwt.internal.cocoa.NSButton;
import dwt.internal.cocoa.NSColor;
import dwt.internal.cocoa.NSRange;
import dwt.internal.cocoa.NSBezierPath;
import dwt.internal.cocoa.NSGraphicsContext;
import dwt.internal.cocoa.NSMutableAttributedString;
import dwt.internal.cocoa.NSTableHeaderCell;
import dwt.internal.cocoa.NSAffineTransform;
import dwt.internal.cocoa.NSMutableIndexSet;
import dwt.internal.cocoa.NSNotification;
import dwt.internal.cocoa.NSDictionary;
import dwt.internal.cocoa.NSMutableDictionary;
import dwt.internal.cocoa.NSMutableParagraphStyle;
import dwt.internal.cocoa.NSNumber;
import dwt.internal.cocoa.SWTTableHeaderCell;
import dwt.internal.cocoa.SWTTableHeaderView;
import dwt.internal.cocoa.SWTTableView;
import dwt.internal.cocoa.SWTScrollView;
import dwt.internal.cocoa.SWTImageTextCell;
import dwt.internal.cocoa.OS;
import Carbon = dwt.internal.c.Carbon;
import dwt.internal.objc.cocoa.Cocoa;
import objc = dwt.internal.objc.runtime;
import dwt.widgets.Composite;
import dwt.widgets.Event;
import dwt.widgets.TableColumn;
import dwt.widgets.TableItem;
import dwt.widgets.TypedListener;
import dwt.widgets.Listener;
import dwt.widgets.Widget;
import dwt.widgets.Display;
import dwt.graphics.Image;
import dwt.graphics.Color;
import dwt.graphics.GC;
import dwt.graphics.GCData;
import dwt.graphics.Rectangle;
import dwt.graphics.Font;
import dwt.graphics.Point;
import dwt.events.ControlListener;
import dwt.events.SelectionListener;

/**
 * Instances of this class implement a selectable user interface
 * object that displays a list of images and strings and issues
 * notification when selected.
 * <p>
 * The item children that may be added to instances of this class
 * must be of type <code>TableItem</code>.
 * </p><p>
 * Style <code>VIRTUAL</code> is used to create a <code>Table</code> whose
 * <code>TableItem</code>s are to be populated by the client on an on-demand basis
 * instead of up-front.  This can provide significant performance improvements for
 * tables that are very large or for which <code>TableItem</code> population is
 * expensive (for example, retrieving values from an external source).
 * </p><p>
 * Here is an example of using a <code>Table</code> with style <code>VIRTUAL</code>:
 * <code><pre>
 *  final Table table = new Table (parent, DWT.VIRTUAL | DWT.BORDER);
 *  table.setItemCount (1000000);
 *  table.addListener (DWT.SetData, new Listener () {
 *      public void handleEvent (Event event) {
 *          TableItem item = cast(TableItem) event.item;
 *          int index = table.indexOf (item);
 *          item.setText ("Item " + index);
 *          System.out_.println (item.getText ());
 *      }
 *  });
 * </pre></code>
 * </p><p>
 * Note that although this class is a subclass of <code>Composite</code>,
 * it does not normally make sense to add <code>Control</code> children to
 * it, or set a layout on it, unless implementing something like a cell
 * editor.
 * </p><p>
 * <dl>
 * <dt><b>Styles:</b></dt>
 * <dd>SINGLE, MULTI, CHECK, FULL_SELECTION, HIDE_SELECTION, VIRTUAL, NO_SCROLL</dd>
 * <dt><b>Events:</b></dt>
 * <dd>Selection, DefaultSelection, SetData, MeasureItem, EraseItem, PaintItem</dd>
 * </dl>
 * </p><p>
 * Note: Only one of the styles SINGLE, and MULTI may be specified.
 * </p><p>
 * IMPORTANT: This class is <em>not</em> intended to be subclassed.
 * </p>
 *
 * @see <a href="http://www.eclipse.org/swt/snippets/#table">Table, TableItem, TableColumn snippets</a>
 * @see <a href="http://www.eclipse.org/swt/examples.php">DWT Example: ControlExample</a>
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 * @noextend This class is not intended to be subclassed by clients.
 */
public class Table : Composite {

    alias Composite.computeSize computeSize;
    alias Composite.createHandle createHandle;
    alias Composite.dragDetect dragDetect;
    alias Composite.setBackground setBackground;
    alias Composite.setBounds setBounds;
    alias Composite.setFont setFont;
    alias Composite.setForeground setForeground;
    alias Composite.updateCursorRects updateCursorRects;

    TableItem [] items;
    TableColumn [] columns;
    TableColumn sortColumn;
    TableItem currentItem;
    NSTableHeaderView headerView;
    NSTableColumn firstColumn, checkColumn;
    NSTextFieldCell dataCell;
    NSButtonCell buttonCell;
    int columnCount, itemCount, lastIndexOf, sortDirection;
    bool ignoreSelect, fixScrollWidth, drawExpansion;
    Rectangle imageBounds;

    static int NEXT_ID;

    static final int FIRST_COLUMN_MINIMUM_WIDTH = 5;
    static final int IMAGE_GAP = 3;
    static final int TEXT_GAP = 2;
    static final int CELL_GAP = 1;

/**
 * Constructs a new instance of this class given its parent
 * and a style value describing its behavior and appearance.
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
 * @see DWT#SINGLE
 * @see DWT#MULTI
 * @see DWT#CHECK
 * @see DWT#FULL_SELECTION
 * @see DWT#HIDE_SELECTION
 * @see DWT#VIRTUAL
 * @see DWT#NO_SCROLL
 * @see Widget#checkSubclass
 * @see Widget#getStyle
 */
public this (Composite parent, int style) {
    super (parent, checkStyle (style));
}

objc.id accessibilityAttributeValue (objc.id id, objc.SEL sel, objc.id arg0) {

    if (accessible !is null) {
        NSString attribute = new NSString(arg0);
        cocoa.id returnValue = accessible.internal_accessibilityAttributeValue(attribute, ACC.CHILDID_SELF);
        if (returnValue !is null) return returnValue.id;
    }

    NSString attributeName = new NSString(arg0);

    // Accessibility Verifier queries for a title or description.  NSTableView doesn't
    // seem to return either, so we return a default description value here.
    if (attributeName.isEqualToString (OS.NSAccessibilityDescriptionAttribute)) {
        return NSString.stringWith("").id;
    }

    return super.accessibilityAttributeValue(id, sel, arg0);
}

void _addListener (int eventType, Listener listener) {
    super._addListener (eventType, listener);
    clearCachedWidth(items);
}

/**
 * Adds the listener to the collection of listeners who will
 * be notified when the user changes the receiver's selection, by sending
 * it one of the messages defined in the <code>SelectionListener</code>
 * interface.
 * <p>
 * When <code>widgetSelected</code> is called, the item field of the event object is valid.
 * If the receiver has the <code>DWT.CHECK</code> style and the check selection changes,
 * the event object detail field contains the value <code>DWT.CHECK</code>.
 * <code>widgetDefaultSelected</code> is typically called when an item is double-clicked.
 * The item field of the event object is valid for default selection, but the detail field is not used.
 * </p>
 *
 * @param listener the listener which should be notified when the user changes the receiver's selection
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the listener is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see SelectionListener
 * @see #removeSelectionListener
 * @see SelectionEvent
 */
public void addSelectionListener (SelectionListener listener) {
    checkWidget ();
    if (listener is null) error (DWT.ERROR_NULL_ARGUMENT);
    TypedListener typedListener = new TypedListener (listener);
    addListener (DWT.Selection, typedListener);
    addListener (DWT.DefaultSelection, typedListener);
}

TableItem _getItem (int index) {
    if ((style & DWT.VIRTUAL) is 0) return items [index];
    if (items [index] !is null) return items [index];
    return items [index] = new TableItem (this, DWT.NULL, -1, false);
}

int calculateWidth (TableItem[] items, int index, GC gc) {
    int width = 0;
    for (int i=0; i < itemCount; i++) {
        TableItem item = items [i];
        if (item !is null && item.cached) {
            width = Math.max (width, item.calculateWidth (index, gc));
        }
    }
    return width;
}

NSSize cellSize (objc.id id, objc.SEL sel) {
    NSSize size = super.cellSize(id, sel);
    NSImage image = (new NSCell(id)).image();
    if (image !is null) size.width += imageBounds.width + IMAGE_GAP;
    if (hooks(DWT.MeasureItem)) {
        void* outValue;
        OS.object_getInstanceVariable(id, Display.SWT_ROW, outValue);
        int rowIndex = cast(NSInteger)outValue;
        TableItem item = _getItem(rowIndex);
        OS.object_getInstanceVariable(id, Display.SWT_COLUMN, outValue);
        cocoa.id tableColumn = cast(cocoa.id)outValue;
        int columnIndex = 0;
        for (int i=0; i<columnCount; i++) {
            if (columns [i].nsColumn is tableColumn) {
                columnIndex = i;
                break;
            }
        }
        sendMeasureItem (item, columnIndex, size);
    }
    return size;
}

bool canDragRowsWithIndexes_atPoint(objc.id id, objc.SEL sel, objc.id arg0, objc.id arg1) {
    NSPoint clickPoint = NSPoint();
    OS.memmove(&clickPoint, arg1, NSPoint.sizeof);
    NSTableView table = cast(NSTableView)view;

    // If the current row is not selected and the user is not attempting to modify the selection, select the row first.
    NSInteger row = table.rowAtPoint(clickPoint);
    NSUInteger modifiers = NSApplication.sharedApplication().currentEvent().modifierFlags();

    bool drag = (state & DRAG_DETECT) !is 0 && hooks (DWT.DragDetect);
    if (drag) {
        if (!table.isRowSelected(row) && (modifiers & (OS.NSCommandKeyMask | OS.NSShiftKeyMask | OS.NSAlternateKeyMask)) is 0) {
            NSIndexSet set = cast(NSIndexSet)(new NSIndexSet()).alloc();
            set = set.initWithIndex(row);
            table.selectRowIndexes (set, false);
            set.release();
        }
    }

    // The clicked row must be selected to initiate a drag.
    return (table.isRowSelected(row) && drag);
}

bool checkData (TableItem item) {
    return checkData (item, indexOf (item));
}

bool checkData (TableItem item, int index) {
    if (item.cached) return true;
    if ((style & DWT.VIRTUAL) !is 0) {
        item.cached = true;
        Event event = new Event ();
        event.item = item;
        event.index = indexOf (item);
        currentItem = item;
        sendEvent (DWT.SetData, event);
        //widget could be disposed at this point
        currentItem = null;
        if (isDisposed () || item.isDisposed ()) return false;
        if (!setScrollWidth (item)) item.redraw (-1);
    }
    return true;
}

static int checkStyle (int style) {
    /*
     * Feature in Windows.  Even when WS_HSCROLL or
     * WS_VSCROLL is not specified, Windows creates
     * trees and tables with scroll bars.  The fix
     * is to set H_SCROLL and V_SCROLL.
     *
     * NOTE: This code appears on all platforms so that
     * applications have consistent scroll bar behavior.
     */
    if ((style & DWT.NO_SCROLL) is 0) {
        style |= DWT.H_SCROLL | DWT.V_SCROLL;
    }
    /* This platform is always FULL_SELECTION */
    style |= DWT.FULL_SELECTION;
    return checkBits (style, DWT.SINGLE, DWT.MULTI, 0, 0, 0, 0);
}

protected void checkSubclass () {
    if (!isValidSubclass ()) error (DWT.ERROR_INVALID_SUBCLASS);
}

/**
 * Clears the item at the given zero-relative index in the receiver.
 * The text, icon and other attributes of the item are set to the default
 * value.  If the table was created with the <code>DWT.VIRTUAL</code> style,
 * these attributes are requested again as needed.
 *
 * @param index the index of the item to clear
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see DWT#VIRTUAL
 * @see DWT#SetData
 *
 * @since 3.0
 */
public void clear (int index) {
    checkWidget ();
    if (!(0 <= index && index < itemCount)) error (DWT.ERROR_INVALID_RANGE);
    TableItem item = items [index];
    if (item !is null) {
        if (currentItem !is item) item.clear ();
        if (currentItem is null) item.redraw (-1);
        setScrollWidth (item);
    }
}
/**
 * Removes the items from the receiver which are between the given
 * zero-relative start and end indices (inclusive).  The text, icon
 * and other attributes of the items are set to their default values.
 * If the table was created with the <code>DWT.VIRTUAL</code> style,
 * these attributes are requested again as needed.
 *
 * @param start the start index of the item to clear
 * @param end the end index of the item to clear
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if either the start or end are not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see DWT#VIRTUAL
 * @see DWT#SetData
 *
 * @since 3.0
 */
public void clear (int start, int end) {
    checkWidget ();
    if (start > end) return;
    if (!(0 <= start && start <= end && end < itemCount)) {
        error (DWT.ERROR_INVALID_RANGE);
    }
    if (start is 0 && end is itemCount - 1) {
        clearAll ();
    } else {
        for (int i=start; i<=end; i++) {
            clear (i);
        }
    }
}

/**
 * Clears the items at the given zero-relative indices in the receiver.
 * The text, icon and other attributes of the items are set to their default
 * values.  If the table was created with the <code>DWT.VIRTUAL</code> style,
 * these attributes are requested again as needed.
 *
 * @param indices the array of indices of the items
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 *    <li>ERROR_NULL_ARGUMENT - if the indices array is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see DWT#VIRTUAL
 * @see DWT#SetData
 *
 * @since 3.0
 */
public void clear (int [] indices) {
    checkWidget ();
    if (indices is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (indices.length is 0) return;
    for (int i=0; i<indices.length; i++) {
        if (!(0 <= indices [i] && indices [i] < itemCount)) {
            error (DWT.ERROR_INVALID_RANGE);
        }
    }
    for (int i=0; i<indices.length; i++) {
        clear (indices [i]);
    }
}

/**
 * Clears all the items in the receiver. The text, icon and other
 * attributes of the items are set to their default values. If the
 * table was created with the <code>DWT.VIRTUAL</code> style, these
 * attributes are requested again as needed.
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see DWT#VIRTUAL
 * @see DWT#SetData
 *
 * @since 3.0
 */
public void clearAll () {
    checkWidget ();
    for (int i=0; i<itemCount; i++) {
        TableItem item = items [i];
        if (item !is null) {
            item.clear ();
        }
    }
    if (currentItem is null && isDrawing ()) view.setNeedsDisplay(true);
    setScrollWidth (items, true);
}

void clearCachedWidth (TableItem[] items) {
    if (items is null) return;
    for (int i = 0; i < items.length; i++) {
        if (items [i] !is null) items [i].width = -1;
    }
}

public Point computeSize (int wHint, int hHint, bool changed) {
    checkWidget ();
    int width = 0;
    if (wHint is DWT.DEFAULT) {
        if (columnCount !is 0) {
            for (int i=0; i<columnCount; i++) {
                width += columns [i].getWidth ();
            }
        } else {
            GC gc = new GC (this);
            width += calculateWidth (items, 0, gc) + CELL_GAP;
            gc.dispose ();
        }
        if ((style & DWT.CHECK) !is 0) width += getCheckColumnWidth ();
    } else {
        width = wHint;
    }
    if (width <= 0) width = DEFAULT_WIDTH;
    int height = 0;
    if (hHint is DWT.DEFAULT) {
        height = itemCount * getItemHeight () + getHeaderHeight();
    } else {
        height = hHint;
    }
    if (height <= 0) height = DEFAULT_HEIGHT;
    Rectangle rect = computeTrim (0, 0, width, height);
    return new Point (rect.width, rect.height);
}

void createColumn (TableItem item, int index) {
    String [] strings = item.strings;
    if (strings !is null) {
        String [] temp = new String [columnCount];
        System.arraycopy (strings, 0, temp, 0, index);
        System.arraycopy (strings, index, temp, index+1, columnCount-index-1);
        temp [index] = "";
        item.strings = temp;
    }
    if (index is 0) item.text = "";
    Image [] images = item.images;
    if (images !is null) {
        Image [] temp = new Image [columnCount];
        System.arraycopy (images, 0, temp, 0, index);
        System.arraycopy (images, index, temp, index+1, columnCount-index-1);
        item.images = temp;
    }
    if (index is 0) item.image = null;
    Color [] cellBackground = item.cellBackground;
    if (cellBackground !is null) {
        Color [] temp = new Color [columnCount];
        System.arraycopy (cellBackground, 0, temp, 0, index);
        System.arraycopy (cellBackground, index, temp, index+1, columnCount-index-1);
        item.cellBackground = temp;
    }
    Color [] cellForeground = item.cellForeground;
    if (cellForeground !is null) {
        Color [] temp = new Color [columnCount];
        System.arraycopy (cellForeground, 0, temp, 0, index);
        System.arraycopy (cellForeground, index, temp, index+1, columnCount-index-1);
        item.cellForeground = temp;
    }
    Font [] cellFont = item.cellFont;
    if (cellFont !is null) {
        Font [] temp = new Font [columnCount];
        System.arraycopy (cellFont, 0, temp, 0, index);
        System.arraycopy (cellFont, index, temp, index+1, columnCount-index-1);
        item.cellFont = temp;
    }
}

void createHandle () {
    NSScrollView scrollWidget = cast(NSScrollView)(new SWTScrollView()).alloc();
    scrollWidget.init();
    scrollWidget.setHasHorizontalScroller ((style & DWT.H_SCROLL) !is 0);
    scrollWidget.setHasVerticalScroller ((style & DWT.V_SCROLL) !is 0);
    scrollWidget.setAutohidesScrollers(true);
    scrollWidget.setBorderType(cast(NSBorderType)(hasBorder() ? OS.NSBezelBorder : OS.NSNoBorder));

    NSTableView widget = cast(NSTableView)(new SWTTableView()).alloc();
    widget.init();
    widget.setAllowsMultipleSelection((style & DWT.MULTI) !is 0);
    widget.setAllowsColumnReordering (false);
    widget.setDataSource(widget);
    widget.setDelegate(widget);
    widget.setColumnAutoresizingStyle (OS.NSTableViewNoColumnAutoresizing);
    NSSize spacing = NSSize();
    spacing.width = spacing.height = CELL_GAP;
    widget.setIntercellSpacing(spacing);
    widget.setDoubleAction(OS.sel_sendDoubleSelection);
    if (!hasBorder()) widget.setFocusRingType(OS.NSFocusRingTypeNone);

    headerView = cast(NSTableHeaderView)(new SWTTableHeaderView ()).alloc ().init ();
    widget.setHeaderView (null);

    NSString str = NSString.stringWith(""); //$NON-NLS-1$
    if ((style & DWT.CHECK) !is 0) {
        checkColumn = cast(NSTableColumn)(new NSTableColumn()).alloc();
        checkColumn = checkColumn.initWithIdentifier(NSString.stringWith(Format("{}",++NEXT_ID)));
        checkColumn.headerCell().setTitle(str);
        widget.addTableColumn (checkColumn);
        checkColumn.setResizingMask(OS.NSTableColumnNoResizing);
        checkColumn.setEditable(false);
        objc.Class cls = NSButton.cellClass (); /* use our custom cell class */
        buttonCell = new NSButtonCell (OS.class_createInstance (cls, 0));
        buttonCell.init ();
        checkColumn.setDataCell (buttonCell);
        buttonCell.setButtonType (OS.NSSwitchButton);
        buttonCell.setImagePosition (OS.NSImageOnly);
        buttonCell.setAllowsMixedState (true);
        checkColumn.setWidth(getCheckColumnWidth());
    }

    firstColumn = cast(NSTableColumn)(new NSTableColumn()).alloc();
    firstColumn = firstColumn.initWithIdentifier(NSString.stringWith(Format("{}", ++NEXT_ID)));
    /*
    * Feature in Cocoa.  If a column's width is too small to show any content
    * then tableView_objectValueForTableColumn_row is never invoked to
    * query for item values, which is a problem for VIRTUAL Tables.  The
    * workaround is to ensure that, for 0-column Tables, the internal first
    * column always has a minimal width that makes this call come in.
    */
    firstColumn.setMinWidth (FIRST_COLUMN_MINIMUM_WIDTH);
    firstColumn.setWidth(0);
    firstColumn.headerCell ().setTitle (str);
    widget.addTableColumn (firstColumn);
    dataCell = cast(NSTextFieldCell)(new SWTImageTextCell ()).alloc ().init ();
    dataCell.setLineBreakMode(OS.NSLineBreakByClipping);
    firstColumn.setDataCell (dataCell);

    scrollView = scrollWidget;
    view = widget;
}

void createItem (TableColumn column, int index) {
    if (!(0 <= index && index <= columnCount)) error (DWT.ERROR_INVALID_RANGE);
    if (columnCount is columns.length) {
        TableColumn [] newColumns = new TableColumn [columnCount + 4];
        System.arraycopy (columns, 0, newColumns, 0, columns.length);
        columns = newColumns;
    }
    NSTableColumn nsColumn;
    if (columnCount is 0) {
        //TODO - clear attributes, alignment etc.
        nsColumn = firstColumn;
        nsColumn.setMinWidth (0);
        firstColumn = null;
    } else {
        //TODO - set attributes, alignment etc.
        nsColumn = cast(NSTableColumn)(new NSTableColumn()).alloc();
        nsColumn = nsColumn.initWithIdentifier(NSString.stringWith(Format("{}", ++NEXT_ID)));
        nsColumn.setMinWidth(0);
        (cast(NSTableView)view).addTableColumn (nsColumn);
        int checkColumn = (style & DWT.CHECK) !is 0 ? 1 : 0;
        (cast(NSTableView)view).moveColumn (columnCount + checkColumn, index + checkColumn);
        nsColumn.setDataCell (dataCell);
    }
    column.createJNIRef ();
    NSTableHeaderCell headerCell = cast(NSTableHeaderCell)(new SWTTableHeaderCell ()).alloc ().init ();
    nsColumn.setHeaderCell (headerCell);
    display.addWidget (headerCell, column);
    column.nsColumn = nsColumn;
    nsColumn.setWidth(0);
    System.arraycopy (columns, index, columns, index + 1, columnCount++ - index);
    columns [index] = column;
    for (int i = 0; i < itemCount; i++) {
        TableItem item = items [i];
        if (item !is null) {
            if (columnCount > 1) {
                createColumn (item, index);
            }
        }
    }
}

void createItem (TableItem item, int index) {
    if (!(0 <= index && index <= itemCount)) error (DWT.ERROR_INVALID_RANGE);
    if (itemCount is items.length) {
        /* Grow the array faster when redraw is off */
        int length = getDrawing () ? items.length + 4 : Math.max (4, items.length * 3 / 2);
        TableItem [] newItems = new TableItem [length];
        System.arraycopy (items, 0, newItems, 0, items.length);
        items = newItems;
    }
    System.arraycopy (items, index, items, index + 1, itemCount++ - index);
    items [index] = item;
    (cast(NSTableView)view).noteNumberOfRowsChanged ();
    if (index !is itemCount) fixSelection (index, true);
}

void createWidget () {
    super.createWidget ();
    items = new TableItem [4];
    columns = new TableColumn [4];
}

Color defaultBackground () {
    return display.getWidgetColor (DWT.COLOR_LIST_BACKGROUND);
}

NSFont defaultNSFont () {
    return display.tableViewFont;
}

Color defaultForeground () {
    return display.getWidgetColor (DWT.COLOR_LIST_FOREGROUND);
}

void deregister () {
    super.deregister ();
    display.removeWidget (headerView);
    display.removeWidget (dataCell);
    if (buttonCell !is null) display.removeWidget (buttonCell);
}

/**
 * Deselects the item at the given zero-relative index in the receiver.
 * If the item at the index was already deselected, it remains
 * deselected. Indices that are out of range are ignored.
 *
 * @param index the index of the item to deselect
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void deselect (int index) {
    checkWidget ();
    if (0 <= index && index < itemCount) {
        NSTableView widget = cast(NSTableView)view;
        ignoreSelect = true;
        widget.deselectRow (index);
        ignoreSelect = false;
    }
}

/**
 * Deselects the items at the given zero-relative indices in the receiver.
 * If the item at the given zero-relative index in the receiver
 * is selected, it is deselected.  If the item at the index
 * was not selected, it remains deselected.  The range of the
 * indices is inclusive. Indices that are out of range are ignored.
 *
 * @param start the start index of the items to deselect
 * @param end the end index of the items to deselect
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void deselect (int start, int end) {
    checkWidget();
    if (start > end) return;
    if (end < 0 || start >= itemCount) return;
    start = Math.max (0, start);
    end = Math.min (itemCount - 1, end);
    if (start is 0 && end is itemCount - 1) {
        deselectAll ();
    } else {
        NSTableView widget = cast(NSTableView)view;
        ignoreSelect = true;
        for (int i=start; i<=end; i++) {
            widget.deselectRow (i);
        }
        ignoreSelect = false;
    }
}

/**
 * Deselects the items at the given zero-relative indices in the receiver.
 * If the item at the given zero-relative index in the receiver
 * is selected, it is deselected.  If the item at the index
 * was not selected, it remains deselected. Indices that are out
 * of range and duplicate indices are ignored.
 *
 * @param indices the array of indices for the items to deselect
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the set of indices is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void deselect (int [] indices) {
    checkWidget ();
    if (indices is null) error (DWT.ERROR_NULL_ARGUMENT);
    NSTableView widget = cast(NSTableView)view;
    ignoreSelect = true;
    for (int i=0; i<indices.length; i++) {
        widget.deselectRow (indices [i]);
    }
    ignoreSelect = false;
}

/**
 * Deselects all selected items in the receiver.
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void deselectAll () {
    checkWidget ();
    NSTableView widget = cast(NSTableView)view;
    ignoreSelect = true;
    widget.deselectAll(null);
    ignoreSelect = false;
}

void destroyItem (TableColumn column) {
    int index = 0;
    while (index < columnCount) {
        if (columns [index] is column) break;
        index++;
    }
    for (int i=0; i<itemCount; i++) {
        TableItem item = items [i];
        if (item !is null) {
            if (columnCount <= 1) {
                item.strings = null;
                item.images = null;
                item.cellBackground = null;
                item.cellForeground = null;
                item.cellFont = null;
            } else {
                if (item.strings !is null) {
                    String [] strings = item.strings;
                    if (index is 0) {
                        item.text = strings [1] !is null ? strings [1] : "";
                    }
                    String [] temp = new String [columnCount - 1];
                    System.arraycopy (strings, 0, temp, 0, index);
                    System.arraycopy (strings, index + 1, temp, index, columnCount - 1 - index);
                    item.strings = temp;
                } else {
                    if (index is 0) item.text = "";
                }
                if (item.images !is null) {
                    Image [] images = item.images;
                    if (index is 0) item.image = images [1];
                    Image [] temp = new Image [columnCount - 1];
                    System.arraycopy (images, 0, temp, 0, index);
                    System.arraycopy (images, index + 1, temp, index, columnCount - 1 - index);
                    item.images = temp;
                } else {
                    if (index is 0) item.image = null;
                }
                if (item.cellBackground !is null) {
                    Color [] cellBackground = item.cellBackground;
                    Color [] temp = new Color [columnCount - 1];
                    System.arraycopy (cellBackground, 0, temp, 0, index);
                    System.arraycopy (cellBackground, index + 1, temp, index, columnCount - 1 - index);
                    item.cellBackground = temp;
                }
                if (item.cellForeground !is null) {
                    Color [] cellForeground = item.cellForeground;
                    Color [] temp = new Color [columnCount - 1];
                    System.arraycopy (cellForeground, 0, temp, 0, index);
                    System.arraycopy (cellForeground, index + 1, temp, index, columnCount - 1 - index);
                    item.cellForeground = temp;
                }
                if (item.cellFont !is null) {
                    Font [] cellFont = item.cellFont;
                    Font [] temp = new Font [columnCount - 1];
                    System.arraycopy (cellFont, 0, temp, 0, index);
                    System.arraycopy (cellFont, index + 1, temp, index, columnCount - 1 - index);
                    item.cellFont = temp;
                }
            }
        }
    }

    int oldIndex = indexOf (column.nsColumn);

    System.arraycopy (columns, index + 1, columns, index, --columnCount - index);
    columns [columnCount] = null;
    if (columnCount is 0) {
        //TODO - reset attributes
        firstColumn = column.nsColumn;
        firstColumn.retain ();
        /*
        * Feature in Cocoa.  If a column's width is too small to show any content
        * then tableView_objectValueForTableColumn_row is never invoked to
        * query for item values, which is a problem for VIRTUAL Tables.  The
        * workaround is to ensure that, for 0-column Tables, the internal first
        * column always has a minimal width that makes this call come in.
        */
        firstColumn.setMinWidth (FIRST_COLUMN_MINIMUM_WIDTH);
        setScrollWidth ();
    } else {
        (cast(NSTableView)view).removeTableColumn(column.nsColumn);
    }

    NSArray array = (cast(NSTableView)view).tableColumns ();
    NSUInteger arraySize = array.count ();
    for (NSUInteger i = oldIndex; i < arraySize; i++) {
        objc.id columnId = array.objectAtIndex (i).id;
        for (int j = 0; j < columnCount; j++) {
            if (columns[j].nsColumn.id is columnId) {
                columns [j].sendEvent (DWT.Move);
                break;
            }
        }
    }
}

void destroyItem (TableItem item) {
    int index = 0;
    while (index < itemCount) {
        if (items [index] is item) break;
        index++;
    }
    if (index !is itemCount - 1) fixSelection (index, false);
    System.arraycopy (items, index + 1, items, index, --itemCount - index);
    items [itemCount] = null;
    (cast(NSTableView)view).noteNumberOfRowsChanged();
    if (itemCount is 0) setTableEmpty ();
}

bool dragDetect(int x, int y, bool filter, bool[] consume) {
    // Let Cocoa determine if a drag is starting and fire the notification when we get the callback.
    return false;
}

void drawInteriorWithFrame_inView (objc.id id, objc.SEL sel, NSRect rect, objc.id view) {
    bool hooksErase = hooks (DWT.EraseItem);
    bool hooksPaint = hooks (DWT.PaintItem);
    bool hooksMeasure = hooks (DWT.MeasureItem);

    NSTextFieldCell cell = new NSTextFieldCell (id);

    NSTableView widget = cast(NSTableView)this.view;
    void* outValue;
    OS.object_getInstanceVariable(id, Display.SWT_ROW, outValue);
    int rowIndex = cast(NSInteger)outValue;
    TableItem item = _getItem(rowIndex);
    OS.object_getInstanceVariable(id, Display.SWT_COLUMN, outValue);
    cocoa.id tableColumn = cast(cocoa.id)outValue;
    NSUInteger nsColumnIndex = widget.tableColumns().indexOfObjectIdenticalTo(tableColumn);
    int columnIndex = 0;
    for (int i=0; i<columnCount; i++) {
        if (columns [i].nsColumn is tableColumn) {
            columnIndex = i;
            break;
        }
    }

    Color background = item.cellBackground !is null ? item.cellBackground [columnIndex] : null;
    if (background is null) background = item.background;
    bool drawBackground = background !is null;
    bool drawForeground = true;
    bool isSelected = cell.isHighlighted();
    bool drawSelection = isSelected;
    bool hasFocus = hooksErase && hasFocus ();

    Color selectionBackground = null, selectionForeground = null;
    if (isSelected && (hooksErase || hooksPaint)) {
        selectionForeground = Color.cocoa_new(display, hasFocus ? display.alternateSelectedControlTextColor : display.selectedControlTextColor);
        selectionBackground = Color.cocoa_new(display, hasFocus ? display.alternateSelectedControlColor : display.secondarySelectedControlColor);
    }

    NSSize contentSize = super.cellSize(id, OS.sel_cellSize);
    NSImage image = cell.image();
    if (image !is null) contentSize.width += imageBounds.width + IMAGE_GAP;
    int contentWidth = cast(int)Math.ceil (contentSize.width);
    NSSize spacing = widget.intercellSpacing();
    int itemHeight = cast(int)Math.ceil (widget.rowHeight() + spacing.height);

    NSRect cellRect = widget.rectOfColumn (nsColumnIndex);
    cellRect.y = rect.y;
    cellRect.height = rect.height + spacing.height;
    if (columnCount is 0) {
        NSRect rowRect = widget.rectOfRow (rowIndex);
        cellRect.width = rowRect.width;
    }
    Cocoa.CGFloat offsetX = 0, offsetY = 0;
    if (hooksPaint || hooksErase) {
        NSRect frameCell = widget.frameOfCellAtColumn(nsColumnIndex, rowIndex);
        offsetX = rect.x - frameCell.x;
        offsetY = rect.y - frameCell.y;
        if (drawExpansion) {
            offsetX -= 0.5f;
            offsetY -= 0.5f;
        }
    }
    int itemX = cast(int)(rect.x - offsetX), itemY = cast(int)(rect.y - offsetY);
    NSGraphicsContext context = NSGraphicsContext.currentContext ();

    if (hooksMeasure) {
        sendMeasureItem(item, columnIndex, contentSize);
    }

    Color userForeground = null;
    if (hooksErase) {
        context.saveGraphicsState();
        NSAffineTransform transform = NSAffineTransform.transform();
        transform.translateXBy(offsetX, offsetY);
        transform.concat();

        GCData data = new GCData ();
        data.paintRectStruct = cellRect;
        data.paintRect = &data.paintRectStruct;
        GC gc = GC.cocoa_new (this, data);
        gc.setFont (item.getFont (columnIndex));
        if (isSelected) {
            gc.setForeground (selectionForeground);
            gc.setBackground (selectionBackground);
        } else {
            gc.setForeground (item.getForeground (columnIndex));
            gc.setBackground (item.getBackground (columnIndex));
        }
        if (!drawExpansion) {
            gc.setClipping (cast(int)(cellRect.x - offsetX), cast(int)(cellRect.y - offsetY), cast(int)cellRect.width, cast(int)cellRect.height);
        }
        Event event = new Event ();
        event.item = item;
        event.gc = gc;
        event.index = columnIndex;
        event.detail = DWT.FOREGROUND;
        if (drawBackground) event.detail |= DWT.BACKGROUND;
        if (isSelected) event.detail |= DWT.SELECTED;
        event.x = cast(int)cellRect.x;
        event.y = cast(int)cellRect.y;
        event.width = cast(int)cellRect.width;
        event.height = cast(int)cellRect.height;
        sendEvent (DWT.EraseItem, event);
        if (!event.doit) {
            drawForeground = drawBackground = drawSelection = false;
        } else {
            drawBackground = drawBackground && (event.detail & DWT.BACKGROUND) !is 0;
            drawForeground = (event.detail & DWT.FOREGROUND) !is 0;
            drawSelection = drawSelection && (event.detail & DWT.SELECTED) !is 0;
        }
        if (!drawSelection && isSelected) {
            userForeground = Color.cocoa_new(display, gc.getForeground().handle);
        }
        gc.dispose ();

        context.restoreGraphicsState();

        if (isDisposed ()) return;
        if (item.isDisposed ()) return;

        if (drawSelection && ((style & DWT.HIDE_SELECTION) is 0 || hasFocus)) {
            cellRect.height = cellRect.height - spacing.height;
            callSuper (widget.id, OS.sel_highlightSelectionInClipRect_, cellRect);
            cellRect.height = cellRect.height + spacing.height;
        }
    }

    if (drawBackground && !drawSelection) {
        context.saveGraphicsState ();
        Carbon.CGFloat[] colorRGB = background.handle;
        NSColor color = NSColor.colorWithDeviceRed (colorRGB[0], colorRGB[1], colorRGB[2], 1f);
        color.setFill ();
        NSBezierPath.fillRect (cellRect);
        context.restoreGraphicsState ();
    }

    if (drawForeground) {
        if ((!drawExpansion || hooksMeasure) && image !is null) {
            NSRect destRect = NSRect();
            destRect.x = rect.x + IMAGE_GAP;
            destRect.y = rect.y + cast(float)Math.ceil((rect.height - imageBounds.height) / 2);
            destRect.width = imageBounds.width;
            destRect.height = imageBounds.height;
            NSRect srcRect = NSRect();
            NSSize size = image.size();
            srcRect.width = size.width;
            srcRect.height = size.height;
            context.saveGraphicsState();
            NSBezierPath.bezierPathWithRect(rect).addClip();
            NSAffineTransform transform = NSAffineTransform.transform();
            transform.scaleXBy(1, -1);
            transform.translateXBy(0, -(destRect.height + 2 * destRect.y));
            transform.concat();
            image.drawInRect(destRect, srcRect, OS.NSCompositeSourceOver, 1);
            context.restoreGraphicsState();
            int imageWidth = imageBounds.width + IMAGE_GAP;
            rect.x = rect.x + imageWidth;
            rect.width = rect.width - imageWidth;
        }
        cell.setHighlighted (false);
        bool callSuper = false;
        if (userForeground !is null) {
            /*
            * Bug in Cocoa.  For some reason, it is not possible to change the
            * foreground color to black when the cell is highlighted. The text
            * still draws white.  The fix is to draw the text and not call super.
            */
            Cocoa.CGFloat [] color = userForeground.handle;
            if (color[0] is 0 && color[1] is 0 && color[2] is 0 && color[3] is 1) {
                NSMutableAttributedString newStr = new NSMutableAttributedString(cell.attributedStringValue().mutableCopy());
                NSRange range = NSRange();
                range.length = newStr.length();
                newStr.removeAttribute(OS.NSForegroundColorAttributeName, range);
                NSRect newRect = NSRect();
                newRect.x = rect.x + TEXT_GAP;
                newRect.y = rect.y;
                newRect.width = rect.width - TEXT_GAP;
                newRect.height = rect.height;
                NSSize size = newStr.size();
                if (newRect.height > size.height) {
                	newRect.y = newRect.y + ((newRect.height - size.height) / 2);
                    newRect.height = size.height;
                }
                newStr.drawInRect(newRect);
                newStr.release();
            } else {
                NSColor nsColor = NSColor.colorWithDeviceRed(color[0], color[1], color[2], color[3]);
                cell.setTextColor(nsColor);
                callSuper = true;
            }
        } else {
            callSuper = true;
        }
        if (callSuper) {
            NSAttributedString attrStr = cell.attributedStringValue();
            NSSize size = attrStr.size();
            if (rect.height > size.height) {
            	rect.y = rect.y + ((rect.height - size.height) / 2);
                rect.height = size.height;
            }
            super.drawInteriorWithFrame_inView(id, sel, rect, view);
        }
    }

    if (hooksPaint) {
        context.saveGraphicsState();
        NSAffineTransform transform = NSAffineTransform.transform();
        transform.translateXBy(offsetX, offsetY);
        transform.concat();

        GCData data = new GCData ();
        data.paintRectStruct = cellRect;
        data.paintRect = &data.paintRectStruct;
        GC gc = GC.cocoa_new (this, data);
        gc.setFont (item.getFont (columnIndex));
        if (drawSelection) {
            gc.setForeground (selectionForeground);
            gc.setBackground (selectionBackground);
        } else {
            gc.setForeground (userForeground !is null ? userForeground : item.getForeground (columnIndex));
            gc.setBackground (item.getBackground (columnIndex));
        }
        if (!drawExpansion) {
            gc.setClipping (cast(int)(cellRect.x - offsetX), cast(int)(cellRect.y - offsetY), cast(int)cellRect.width, cast(int)cellRect.height);
        }
        Event event = new Event ();
        event.item = item;
        event.gc = gc;
        event.index = columnIndex;
        if (drawForeground) event.detail |= DWT.FOREGROUND;
        if (drawBackground) event.detail |= DWT.BACKGROUND;
        if (drawSelection) event.detail |= DWT.SELECTED;
        event.x = itemX;
        event.y = itemY;
        event.width = contentWidth;
        event.height = itemHeight;
        sendEvent (DWT.PaintItem, event);
        gc.dispose ();

        context.restoreGraphicsState();
    }
}

void drawWithExpansionFrame_inView (objc.id id, objc.SEL sel, NSRect cellFrame, objc.id view) {
    drawExpansion = true;
    super.drawWithExpansionFrame_inView(id, sel, cellFrame, view);
    drawExpansion = false;
}

void drawRect(objc.id id, objc.SEL sel, NSRect rect) {
    fixScrollWidth = false;
    super.drawRect(id, sel, rect);
    if (isDisposed ()) return;
    if (fixScrollWidth) {
        fixScrollWidth = false;
        if (setScrollWidth (items, true)) view.setNeedsDisplay(true);
    }
}

NSRect expansionFrameWithFrame_inView(objc.id id, objc.SEL sel, NSRect cellRect, objc.id view) {
    if (toolTipText is null) {
        NSRect rect = super.expansionFrameWithFrame_inView(id, sel, cellRect, view);
        NSCell cell = new NSCell(id);
        if (rect.width !is 0 && rect.height !is 0) {
            if (hooks(DWT.MeasureItem)) {
                NSSize cellSize = cell.cellSize();
                cellRect.width = cellSize.width;
                return cellRect;
            }
        } else {
            NSRect expansionRect;
            if (hooks(DWT.MeasureItem)) {
                expansionRect = cellRect;
                NSSize cellSize = cell.cellSize();
                expansionRect.width = cellSize.width;
            } else {
                expansionRect = cell.titleRectForBounds(cellRect);
                NSSize cellSize = super.cellSize(id, OS.sel_cellSize);
                expansionRect.width = cellSize.width;
            }
            NSRect contentRect = scrollView.contentView().bounds();
            OS.NSIntersectionRect(contentRect, expansionRect, contentRect);
            if (!OS.NSEqualRects(expansionRect, contentRect)) {
                return expansionRect;
            }
        }
        return rect;
    }
    return NSRect();
}

Widget findTooltip (NSPoint pt) {
    NSTableView widget = cast(NSTableView)view;
    NSTableHeaderView headerView = widget.headerView();
    if (headerView !is null) {
        pt = headerView.convertPoint_fromView_ (pt, null);
        NSInteger index = headerView.columnAtPoint (pt);
        if (index !is -1) {
            NSArray nsColumns = widget.tableColumns ();
            cocoa.id nsColumn = nsColumns.objectAtIndex (index);
            for (int i = 0; i < columnCount; i++) {
                TableColumn column = columns [i];
                if (column.nsColumn.id is nsColumn.id) {
                    return column;
                }
            }
        }
    }
    return super.findTooltip (pt);
}

void fixSelection (int index, bool add) {
    int [] selection = getSelectionIndices ();
    if (selection.length is 0) return;
    int newCount = 0;
    bool fix = false;
    for (int i = 0; i < selection.length; i++) {
        if (!add && selection [i] is index) {
            fix = true;
        } else {
            int newIndex = newCount++;
            selection [newIndex] = selection [i];
            if (selection [newIndex] >= index) {
                selection [newIndex] += add ? 1 : -1;
                fix = true;
            }
        }
    }
    if (fix) select (selection, newCount, true);
}

int getCheckColumnWidth () {
    return cast(int)checkColumn.dataCell().cellSize().width;
}

public Rectangle getClientArea () {
    checkWidget ();
    Rectangle rect = super.getClientArea ();
    NSTableHeaderView headerView = (cast(NSTableView) view).headerView ();
    if (headerView !is null) {
        int height =  cast(int) headerView.bounds ().height;
        rect.y -= height;
        rect.height += height;
    }
    return rect;
}

TableColumn getColumn (cocoa.id id) {
    for (int i = 0; i < columnCount; i++) {
        if (columns[i].nsColumn.id is id.id) {
            return columns[i];
        }
    }
    return null;
}

/**
 * Returns the column at the given, zero-relative index in the
 * receiver. Throws an exception if the index is out of range.
 * Columns are returned in the order that they were created.
 * If no <code>TableColumn</code>s were created by the programmer,
 * this method will throw <code>ERROR_INVALID_RANGE</code> despite
 * the fact that a single column of data may be visible in the table.
 * This occurs when the programmer uses the table like a list, adding
 * items but never creating a column.
 *
 * @param index the index of the column to return
 * @return the column at the given index
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#getColumnOrder()
 * @see Table#setColumnOrder(int[])
 * @see TableColumn#getMoveable()
 * @see TableColumn#setMoveable(bool)
 * @see DWT#Move
 */
public TableColumn getColumn (int index) {
    checkWidget ();
    if (!(0 <=index && index < columnCount)) error (DWT.ERROR_INVALID_RANGE);
    return columns [index];
}

/**
 * Returns the number of columns contained in the receiver.
 * If no <code>TableColumn</code>s were created by the programmer,
 * this value is zero, despite the fact that visually, one column
 * of items may be visible. This occurs when the programmer uses
 * the table like a list, adding items but never creating a column.
 *
 * @return the number of columns
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getColumnCount () {
    checkWidget ();
    return columnCount;
}

/**
 * Returns an array of zero-relative integers that map
 * the creation order of the receiver's items to the
 * order in which they are currently being displayed.
 * <p>
 * Specifically, the indices of the returned array represent
 * the current visual order of the items, and the contents
 * of the array represent the creation order of the items.
 * </p><p>
 * Note: This is not the actual structure used by the receiver
 * to maintain its list of items, so modifying the array will
 * not affect the receiver.
 * </p>
 *
 * @return the current visual order of the receiver's items
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#setColumnOrder(int[])
 * @see TableColumn#getMoveable()
 * @see TableColumn#setMoveable(bool)
 * @see DWT#Move
 *
 * @since 3.1
 */
public int [] getColumnOrder () {
    checkWidget ();
    int [] order = new int [columnCount];
    for (int i = 0; i < columnCount; i++) {
        TableColumn column = columns [i];
        int index = indexOf (column.nsColumn);
        if ((style & DWT.CHECK) !is 0) index -= 1;
        order [index] = i;
    }
    return order;
}

/**
 * Returns an array of <code>TableColumn</code>s which are the
 * columns in the receiver.  Columns are returned in the order
 * that they were created.  If no <code>TableColumn</code>s were
 * created by the programmer, the array is empty, despite the fact
 * that visually, one column of items may be visible. This occurs
 * when the programmer uses the table like a list, adding items but
 * never creating a column.
 * <p>
 * Note: This is not the actual structure used by the receiver
 * to maintain its list of items, so modifying the array will
 * not affect the receiver.
 * </p>
 *
 * @return the items in the receiver
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#getColumnOrder()
 * @see Table#setColumnOrder(int[])
 * @see TableColumn#getMoveable()
 * @see TableColumn#setMoveable(bool)
 * @see DWT#Move
 */
public TableColumn [] getColumns () {
    checkWidget ();
    TableColumn [] result = new TableColumn [columnCount];
    System.arraycopy (columns, 0, result, 0, columnCount);
    return result;
}

/**
 * Returns the width in pixels of a grid line.
 *
 * @return the width of a grid line in pixels
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getGridLineWidth () {
    checkWidget ();
    return 0;
}

/**
 * Returns the height of the receiver's header
 *
 * @return the height of the header or zero if the header is not visible
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 2.0
 */
public int getHeaderHeight () {
    checkWidget ();
    NSTableHeaderView headerView = (cast(NSTableView)view).headerView();
    if (headerView is null) return 0;
    return cast(int)headerView.bounds().height;
}

/**
 * Returns <code>true</code> if the receiver's header is visible,
 * and <code>false</code> otherwise.
 * <p>
 * If one of the receiver's ancestors is not visible or some
 * other condition makes the receiver not visible, this method
 * may still indicate that it is considered visible even though
 * it may not actually be showing.
 * </p>
 *
 * @return the receiver's header's visibility state
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public bool getHeaderVisible () {
    checkWidget ();
    return (cast(NSTableView)view).headerView() !is null;
}

/**
 * Returns the item at the given, zero-relative index in the
 * receiver. Throws an exception if the index is out of range.
 *
 * @param index the index of the item to return
 * @return the item at the given index
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public TableItem getItem (int index) {
    checkWidget ();
    if (!(0 <= index && index < itemCount)) error (DWT.ERROR_INVALID_RANGE);
    return _getItem (index);
}

/**
 * Returns the item at the given point in the receiver
 * or null if no such item exists. The point is in the
 * coordinate system of the receiver.
 * <p>
 * The item that is returned represents an item that could be selected by the user.
 * For example, if selection only occurs in items in the first column, then null is
 * returned if the point is outside of the item.
 * Note that the DWT.FULL_SELECTION style hint, which specifies the selection policy,
 * determines the extent of the selection.
 * </p>
 *
 * @param point the point used to locate the item
 * @return the item at the given point, or null if the point is not in a selectable item
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the point is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public TableItem getItem (Point point) {
    checkWidget ();
    NSTableView widget = cast(NSTableView)view;
    NSPoint pt = NSPoint();
    pt.x = point.x;
    pt.y = point.y;
    NSInteger row = widget.rowAtPoint(pt);
    if (row is -1) return null;
    return items[row];
}

/**
 * Returns the number of items contained in the receiver.
 *
 * @return the number of items
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getItemCount () {
    checkWidget ();
    return itemCount;
}

/**
 * Returns the height of the area which would be used to
 * display <em>one</em> of the items in the receiver.
 *
 * @return the height of one item
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getItemHeight () {
    checkWidget ();
    return cast(int)(cast(NSTableView)view).rowHeight() + CELL_GAP;
}

/**
 * Returns a (possibly empty) array of <code>TableItem</code>s which
 * are the items in the receiver.
 * <p>
 * Note: This is not the actual structure used by the receiver
 * to maintain its list of items, so modifying the array will
 * not affect the receiver.
 * </p>
 *
 * @return the items in the receiver
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public TableItem [] getItems () {
    checkWidget ();
    TableItem [] result = new TableItem [itemCount];
    if ((style & DWT.VIRTUAL) !is 0) {
        for (int i=0; i<itemCount; i++) {
            result [i] = _getItem (i);
        }
    } else {
        System.arraycopy (items, 0, result, 0, itemCount);
    }
    return result;
}

/**
 * Returns <code>true</code> if the receiver's lines are visible,
 * and <code>false</code> otherwise. Note that some platforms draw
 * grid lines while others may draw alternating row colors.
 * <p>
 * If one of the receiver's ancestors is not visible or some
 * other condition makes the receiver not visible, this method
 * may still indicate that it is considered visible even though
 * it may not actually be showing.
 * </p>
 *
 * @return the visibility state of the lines
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public bool getLinesVisible () {
    checkWidget ();
    return (cast(NSTableView)view).usesAlternatingRowBackgroundColors();
}

/**
 * Returns an array of <code>TableItem</code>s that are currently
 * selected in the receiver. The order of the items is unspecified.
 * An empty array indicates that no items are selected.
 * <p>
 * Note: This is not the actual structure used by the receiver
 * to maintain its selection, so modifying the array will
 * not affect the receiver.
 * </p>
 * @return an array representing the selection
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public TableItem [] getSelection () {
    checkWidget ();
    NSTableView widget = cast(NSTableView)view;
    if (widget.numberOfSelectedRows() is 0) {
        return new TableItem [0];
    }
    NSIndexSet selection = widget.selectedRowIndexes();
    NSUInteger count = selection.count();
    NSUInteger [] indexBuffer = new NSUInteger [count];
    selection.getIndexes(indexBuffer.ptr, count, null);
    TableItem [] result = new TableItem  [count];
    for (NSUInteger i=0; i<count; i++) {
        result [i] = _getItem (indexBuffer [i]);
    }
    return result;
}

/**
 * Returns the number of selected items contained in the receiver.
 *
 * @return the number of selected items
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getSelectionCount () {
    checkWidget ();
    return cast(int)/*64*/(cast(NSTableView)view).numberOfSelectedRows();
}

/**
 * Returns the zero-relative index of the item which is currently
 * selected in the receiver, or -1 if no item is selected.
 *
 * @return the index of the selected item
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getSelectionIndex () {
    checkWidget ();
    NSTableView widget = cast(NSTableView)view;
    if (widget.numberOfSelectedRows() is 0) {
        return -1;
    }
    NSIndexSet selection = widget.selectedRowIndexes();
    NSUInteger count = selection.count();
    NSUInteger [] result = new NSUInteger [count];
    selection.getIndexes(result.ptr, count, null);
    return cast(int)/*64*/result [0];
}

/**
 * Returns the zero-relative indices of the items which are currently
 * selected in the receiver. The order of the indices is unspecified.
 * The array is empty if no items are selected.
 * <p>
 * Note: This is not the actual structure used by the receiver
 * to maintain its selection, so modifying the array will
 * not affect the receiver.
 * </p>
 * @return the array of indices of the selected items
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int [] getSelectionIndices () {
    checkWidget ();
    NSTableView widget = cast(NSTableView)view;
    if (widget.numberOfSelectedRows() is 0) {
        return new int [0];
    }
    NSIndexSet selection = widget.selectedRowIndexes();
    NSUInteger count = selection.count();
    NSUInteger [] indices = new NSUInteger [count];
    selection.getIndexes(indices.ptr, count, null);
    int [] result = new int [count];
    for (size_t i = 0; i < indices.length; i++) {
        result [i] = cast(int)/*64*/indices [i];
    }
    return result;
}

/**
 * Returns the column which shows the sort indicator for
 * the receiver. The value may be null if no column shows
 * the sort indicator.
 *
 * @return the sort indicator
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see #setSortColumn(TableColumn)
 *
 * @since 3.2
 */
public TableColumn getSortColumn () {
    checkWidget ();
    return sortColumn;
}

/**
 * Returns the direction of the sort indicator for the receiver.
 * The value will be one of <code>UP</code>, <code>DOWN</code>
 * or <code>NONE</code>.
 *
 * @return the sort direction
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see #setSortDirection(int)
 *
 * @since 3.2
 */
public int getSortDirection () {
    checkWidget ();
    return sortDirection;
}

/**
 * Returns the zero-relative index of the item which is currently
 * at the top of the receiver. This index can change when items are
 * scrolled or new items are added or removed.
 *
 * @return the index of the top item
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int getTopIndex () {
    checkWidget ();
    //TODO - partial item at the top
    NSRect rect = scrollView.documentVisibleRect();
    NSPoint point = NSPoint();
    point.x = rect.x;
    point.y = rect.y;
    return cast(int)/*64*/(cast(NSTableView)view).rowAtPoint(point);
}

void highlightSelectionInClipRect(objc.id id, objc.SEL sel, objc.id rect) {
    if (hooks (DWT.EraseItem)) return;
    if ((style & DWT.HIDE_SELECTION) !is 0 && !hasFocus()) return;
    NSRect clipRect = NSRect ();
    OS.memmove (&clipRect, rect, NSRect.sizeof);
    callSuper (id, sel, clipRect);
}

objc.id hitTestForEvent (objc.id id, objc.SEL sel, objc.id event, NSRect rect, objc.id controlView) {
    /*
    * For some reason, the cell class needs to implement hitTestForEvent:inRect:ofView:,
    * otherwise the double action selector is not called properly.
    */
    return callSuper(id, sel, event, rect, controlView);
}

objc.id image (objc.id id, objc.SEL sel) {
    void* image;
    OS.object_getInstanceVariable(id, Display.SWT_IMAGE, image);
    return cast(objc.id)image;
}

NSRect imageRectForBounds (objc.id id, objc.SEL sel, NSRect cellFrame) {
    NSImage image = (new NSCell(id)).image();
    if (image !is null) {
        cellFrame.x = cellFrame.x + IMAGE_GAP;
        cellFrame.width = imageBounds.width;
        cellFrame.height = imageBounds.height;
    }
    return cellFrame;
}

int indexOf (NSTableColumn column) {
    return cast(int)/*64*/(cast(NSTableView)view).tableColumns().indexOfObjectIdenticalTo(column);
}

/**
 * Searches the receiver's list starting at the first column
 * (index 0) until a column is found that is equal to the
 * argument, and returns the index of that column. If no column
 * is found, returns -1.
 *
 * @param column the search column
 * @return the index of the column
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the column is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int indexOf (TableColumn column) {
    checkWidget ();
    if (column is null) error (DWT.ERROR_NULL_ARGUMENT);
    for (int i=0; i<columnCount; i++) {
        if (columns [i] is column) return i;
    }
    return -1;
}

/**
 * Searches the receiver's list starting at the first item
 * (index 0) until an item is found that is equal to the
 * argument, and returns the index of that item. If no item
 * is found, returns -1.
 *
 * @param item the search item
 * @return the index of the item
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the item is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public int indexOf (TableItem item) {
    checkWidget ();
    if (item is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (1 <= lastIndexOf && lastIndexOf < itemCount - 1) {
        if (items [lastIndexOf] is item) return lastIndexOf;
        if (items [lastIndexOf + 1] is item) return ++lastIndexOf;
        if (items [lastIndexOf - 1] is item) return --lastIndexOf;
    }
    if (lastIndexOf < itemCount / 2) {
        for (int i=0; i<itemCount; i++) {
            if (items [i] is item) return lastIndexOf = i;
        }
    } else {
        for (int i=itemCount - 1; i>=0; --i) {
            if (items [i] is item) return lastIndexOf = i;
        }
    }
    return -1;
}

/**
 * Returns <code>true</code> if the item is selected,
 * and <code>false</code> otherwise.  Indices out of
 * range are ignored.
 *
 * @param index the index of the item
 * @return the selection state of the item at the index
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public bool isSelected (int index) {
    checkWidget ();
    if (!(0 <= index && index < itemCount)) return false;
    return (cast(NSTableView)view).isRowSelected(index);
}

bool isTrim (NSView view) {
    if (super.isTrim (view)) return true;
    return view.id is headerView.id;
}

objc.id menuForEvent(objc.id id, objc.SEL sel, objc.id theEvent) {
    if (id !is headerView.id) {
        /*
         * Feature in Cocoa: Table views do not change the selection when the user
         * right-clicks or control-clicks on an NSTableView or its subclasses. Fix is to select the
         * clicked-on row ourselves.
         */
        NSEvent event = new NSEvent(theEvent);
        NSTableView table = cast(NSTableView)view;

        // get the current selections for the table view.
        NSIndexSet selectedRowIndexes = table.selectedRowIndexes();

        // select the row that was clicked before showing the menu for the event
        NSPoint mousePoint = view.convertPoint_fromView_(event.locationInWindow(), null);
        NSInteger row = table.rowAtPoint(mousePoint);

        // figure out if the row that was just clicked on is currently selected
        if (selectedRowIndexes.containsIndex(row) is false) {
            NSIndexSet set = cast(NSIndexSet)(new NSIndexSet()).alloc();
            set = set.initWithIndex(row);
            table.selectRowIndexes (set, false);
            set.release();
        }
        // else that row is currently selected, so don't change anything.
    }
    return super.menuForEvent(id, sel, theEvent);
}

void mouseDown (objc.id id, objc.SEL sel, objc.id theEvent) {
    if (headerView !is null && id is headerView.id) {
        NSTableView widget = cast(NSTableView)view;
        widget.setAllowsColumnReordering(false);
        NSPoint pt = headerView.convertPoint_fromView_((new NSEvent(theEvent)).locationInWindow(), null);
        NSInteger nsIndex = headerView.columnAtPoint(pt);
        if (nsIndex !is -1) {
            cocoa.id nsColumn = widget.tableColumns().objectAtIndex(nsIndex);
            for (int i = 0; i < columnCount; i++) {
                if (columns[i].nsColumn.id is nsColumn.id) {
                    widget.setAllowsColumnReordering(columns[i].movable);
                    break;
                }
            }
        }
    }
    else if (id is view.id) {
        // Bug/feature in Cocoa:  If the table has a context menu we just set it visible instead of returning
        // it from menuForEvent:.  This has the side effect, however, of sending control-click to the NSTableView,
        // which is interpreted as a single click that clears the selection.  Fix is to ignore control-click if the
        // view has a context menu.
        NSEvent event = new NSEvent(theEvent);
        if ((event.modifierFlags() & OS.NSControlKeyMask) !is 0) return;
    }
    super.mouseDown(id, sel, theEvent);
}

/*
 * Feature in Cocoa.  If a checkbox is in multi-state mode, nextState cycles
 * from off to mixed to on and back to off again.  This will cause the on state
 * to momentarily appear while clicking on the checkbox.  To avoid this,
 * override [NSCell nextState] to go directly to the desired state.
 */
objc.id nextState (objc.id id, objc.SEL sel) {
    NSTableView tableView = cast(NSTableView)view;
    NSInteger index = tableView.selectedRow ();
    TableItem item = items[index];
    if (item.grayed) {
        return cast(objc.id)(item.checked ? OS.NSOffState : OS.NSMixedState);
    }
    return cast(objc.id)(item.checked ? OS.NSOffState : OS.NSOnState);
}

void register () {
    super.register ();
    display.addWidget (headerView, this);
    display.addWidget (dataCell, this);
    if (buttonCell !is null) display.addWidget (buttonCell, this);
}

void releaseChildren (bool destroy) {
    if (items !is null) {
        for (int i=0; i<itemCount; i++) {
            TableItem item = items [i];
            if (item !is null && !item.isDisposed ()) {
                item.release (false);
            }
        }
        items = null;
    }
    if (columns !is null) {
        for (int i=0; i<columnCount; i++) {
            TableColumn column = columns [i];
            if (column !is null && !column.isDisposed ()) {
                column.release (false);
            }
        }
        columns = null;
    }
    super.releaseChildren (destroy);
}

void releaseHandle () {
    super.releaseHandle ();
    if (headerView !is null) headerView.release();
    headerView = null;
    if (firstColumn !is null) firstColumn.release();
    firstColumn = null;
    if (checkColumn !is null) checkColumn.release();
    checkColumn = null;
    if (dataCell !is null) dataCell.release();
    dataCell = null;
    if (buttonCell !is null) buttonCell.release();
    buttonCell = null;
}

void releaseWidget () {
    super.releaseWidget ();
    currentItem = null;
    sortColumn = null;
}

/**
 * Removes the item from the receiver at the given
 * zero-relative index.
 *
 * @param index the index for the item
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void remove (int index) {
    checkWidget ();
    if (!(0 <= index && index < itemCount)) error (DWT.ERROR_INVALID_RANGE);
    TableItem item = items [index];
    if (item !is null) item.release (false);
    if (index !is itemCount - 1) fixSelection (index, false);
    System.arraycopy (items, index + 1, items, index, --itemCount - index);
    items [itemCount] = null;
    (cast(NSTableView)view).noteNumberOfRowsChanged();
    if (itemCount is 0) {
        setTableEmpty ();
    }
}

/**
 * Removes the items from the receiver which are
 * between the given zero-relative start and end
 * indices (inclusive).
 *
 * @param start the start of the range
 * @param end the end of the range
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if either the start or end are not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void remove (int start, int end) {
    checkWidget ();
    if (start > end) return;
    if (!(0 <= start && start <= end && end < itemCount)) {
        error (DWT.ERROR_INVALID_RANGE);
    }
    if (start is 0 && end is itemCount - 1) {
        removeAll ();
    } else {
        int length = end - start + 1;
        for (int i=0; i<length; i++) remove (start);
    }
}

/**
 * Removes the items from the receiver's list at the given
 * zero-relative indices.
 *
 * @param indices the array of indices of the items
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_RANGE - if the index is not between 0 and the number of elements in the list minus 1 (inclusive)</li>
 *    <li>ERROR_NULL_ARGUMENT - if the indices array is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void remove (int [] indices) {
    checkWidget ();
    if (indices is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (indices.length is 0) return;
    int [] newIndices = new int [indices.length];
    System.arraycopy (indices, 0, newIndices, 0, indices.length);
    sort (newIndices);
    int start = newIndices [newIndices.length - 1], end = newIndices [0];
    if (!(0 <= start && start <= end && end < itemCount)) {
        error (DWT.ERROR_INVALID_RANGE);
    }
    int last = -1;
    for (int i=0; i<newIndices.length; i++) {
        int index = newIndices [i];
        if (index !is last) {
            remove (index);
            last = index;
        }
    }
}

/**
 * Removes all of the items from the receiver.
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void removeAll () {
    checkWidget ();
    for (int i=0; i<itemCount; i++) {
        TableItem item = items [i];
        if (item !is null && !item.isDisposed ()) item.release (false);
    }
    setTableEmpty ();
    (cast(NSTableView)view).noteNumberOfRowsChanged();
}

/**
 * Removes the listener from the collection of listeners who will
 * be notified when the user changes the receiver's selection.
 *
 * @param listener the listener which should no longer be notified
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the listener is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see SelectionListener
 * @see #addSelectionListener(SelectionListener)
 */
public void removeSelectionListener(SelectionListener listener) {
    checkWidget ();
    if (listener is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (eventTable is null) return;
    eventTable.unhook (DWT.Selection, listener);
    eventTable.unhook (DWT.DefaultSelection,listener);
}

/**
 * Selects the item at the given zero-relative index in the receiver.
 * If the item at the index was already selected, it remains
 * selected. Indices that are out of range are ignored.
 *
 * @param index the index of the item to select
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void select (int index) {
    checkWidget ();
    if (0 <= index && index < itemCount) {
        NSIndexSet set = cast(NSIndexSet)(new NSIndexSet()).alloc();
        set = set.initWithIndex(index);
        NSTableView widget = cast(NSTableView)view;
        ignoreSelect = true;
        widget.selectRowIndexes(set, (style & DWT.MULTI) !is 0);
        ignoreSelect = false;
        set.release();
    }
}

/**
 * Selects the items in the range specified by the given zero-relative
 * indices in the receiver. The range of indices is inclusive.
 * The current selection is not cleared before the new items are selected.
 * <p>
 * If an item in the given range is not selected, it is selected.
 * If an item in the given range was already selected, it remains selected.
 * Indices that are out of range are ignored and no items will be selected
 * if start is greater than end.
 * If the receiver is single-select and there is more than one item in the
 * given range, then all indices are ignored.
 * </p>
 *
 * @param start the start of the range
 * @param end the end of the range
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#setSelection(int,int)
 */
public void select (int start, int end) {
    checkWidget ();
    if (end < 0 || start > end || ((style & DWT.SINGLE) !is 0 && start !is end)) return;
    if (itemCount is 0 || start >= itemCount) return;
    if (start is 0 && end is itemCount - 1) {
        selectAll ();
    } else {
        start = Math.max (0, start);
        end = Math.min (end, itemCount - 1);
        NSRange range = NSRange();
        range.location = start;
        range.length = end - start + 1;
        NSIndexSet set = cast(NSIndexSet)(new NSIndexSet()).alloc();
        set = set.initWithIndexesInRange(range);
        NSTableView widget = cast(NSTableView)view;
        ignoreSelect = true;
        widget.selectRowIndexes(set, (style & DWT.MULTI) !is 0);
        ignoreSelect = false;
        set.release();
    }
}

/**
 * Selects the items at the given zero-relative indices in the receiver.
 * The current selection is not cleared before the new items are selected.
 * <p>
 * If the item at a given index is not selected, it is selected.
 * If the item at a given index was already selected, it remains selected.
 * Indices that are out of range and duplicate indices are ignored.
 * If the receiver is single-select and multiple indices are specified,
 * then all indices are ignored.
 * </p>
 *
 * @param indices the array of indices for the items to select
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the array of indices is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#setSelection(int[])
 */
public void select (int [] indices) {
    checkWidget ();
    if (indices is null) error (DWT.ERROR_NULL_ARGUMENT);
    int length = indices.length;
    if (length is 0 || ((style & DWT.SINGLE) !is 0 && length > 1)) return;
    int count = 0;
    NSMutableIndexSet set = cast(NSMutableIndexSet)(new NSMutableIndexSet()).alloc().init();
    for (int i=0; i<length; i++) {
        int index = indices [i];
        if (index >= 0 && index < itemCount) {
            set.addIndex (indices [i]);
            count++;
        }
    }
    if (count > 0) {
        NSTableView widget = cast(NSTableView)view;
        ignoreSelect = true;
        widget.selectRowIndexes(set, (style & DWT.MULTI) !is 0);
        ignoreSelect = false;
    }
    set.release();
}

void select (int [] indices, int count, bool clear) {
    NSMutableIndexSet set = cast(NSMutableIndexSet)(new NSMutableIndexSet()).alloc().init();
    for (int i=0; i<count; i++) set.addIndex (indices [i]);
    NSTableView widget = cast(NSTableView)view;
    ignoreSelect = true;
    widget.selectRowIndexes(set, !clear);
    ignoreSelect = false;
    set.release();
}

/**
 * Selects all of the items in the receiver.
 * <p>
 * If the receiver is single-select, do nothing.
 * </p>
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void selectAll () {
    checkWidget ();
    if ((style & DWT.SINGLE) !is 0) return;
    NSTableView widget = cast(NSTableView)view;
    ignoreSelect = true;
    widget.selectAll(null);
    ignoreSelect = false;
}

void updateBackground () {
    NSColor nsColor = null;
    if (backgroundImage !is null) {
        nsColor = NSColor.colorWithPatternImage(backgroundImage.handle);
    } else if (background !is null) {
        nsColor = NSColor.colorWithDeviceRed(background[0], background[1], background[2], background[3]);
    }
    (cast(NSTableView) view).setBackgroundColor (nsColor);
}

/**
 * Sets the order that the items in the receiver should
 * be displayed in to the given argument which is described
 * in terms of the zero-relative ordering of when the items
 * were added.
 *
 * @param order the new order to display the items
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the item order is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the item order is not the same length as the number of items</li>
 * </ul>
 *
 * @see Table#getColumnOrder()
 * @see TableColumn#getMoveable()
 * @see TableColumn#setMoveable(bool)
 * @see DWT#Move
 *
 * @since 3.1
 */
public void setColumnOrder (int [] order) {
    checkWidget ();
    if (order is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (columnCount is 0) {
        if (order.length !is 0) error (DWT.ERROR_INVALID_ARGUMENT);
        return;
    }
    if (order.length !is columnCount) error (DWT.ERROR_INVALID_ARGUMENT);
    int [] oldOrder = getColumnOrder ();
    bool reorder = false;
    bool [] seen = new bool [columnCount];
    for (int i=0; i<order.length; i++) {
        int index = order [i];
        if (index < 0 || index >= columnCount) error (DWT.ERROR_INVALID_ARGUMENT);
        if (seen [index]) error (DWT.ERROR_INVALID_ARGUMENT);
        seen [index] = true;
        if (order [i] !is oldOrder [i]) reorder = true;
    }
    if (reorder) {
        NSTableView tableView = cast(NSTableView)view;
        int [] oldX = new int [oldOrder.length];
        int check = (style & DWT.CHECK) !is 0 ? 1 : 0;
        for (int i=0; i<oldOrder.length; i++) {
            int index = oldOrder[i];
            oldX [index] = cast(int)tableView.rectOfColumn (i + check).x;
        }
        int [] newX = new int [order.length];
        for (int i=0; i<order.length; i++) {
            int index = order [i];
            TableColumn column = columns[index];
            int oldIndex = indexOf (column.nsColumn);
            int newIndex = i + check;
            tableView.moveColumn (oldIndex, newIndex);
            newX [index] = cast(int)tableView.rectOfColumn (newIndex).x;
        }
        TableColumn[] newColumns = new TableColumn [columnCount];
        System.arraycopy (columns, 0, newColumns, 0, columnCount);
        for (int i=0; i<columnCount; i++) {
            TableColumn column = newColumns [i];
            if (!column.isDisposed ()) {
                if (newX [i] !is oldX [i]) {
                    column.sendEvent (DWT.Move);
                }
            }
        }
    }
}

void setFont (NSFont font) {
    super.setFont (font);
    setItemHeight (null, font, !hooks (DWT.MeasureItem));
    view.setNeedsDisplay (true);
    clearCachedWidth (items);
    setScrollWidth (items, true);
}

/**
 * Marks the receiver's header as visible if the argument is <code>true</code>,
 * and marks it invisible otherwise.
 * <p>
 * If one of the receiver's ancestors is not visible or some
 * other condition makes the receiver not visible, marking
 * it visible may not actually cause it to be displayed.
 * </p>
 *
 * @param show the new visibility state
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setHeaderVisible (bool show) {
    checkWidget ();
    (cast(NSTableView)view).setHeaderView (show ? headerView : null);
}

void setImage (objc.id id, objc.SEL sel, objc.id arg0) {
    OS.object_setInstanceVariable(id, Display.SWT_IMAGE, arg0);
}

/**
 * Sets the number of items contained in the receiver.
 *
 * @param count the number of items
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.0
 */
public void setItemCount (int count) {
    checkWidget ();
    count = Math.max (0, count);
    if (count is itemCount) return;
    if (count is itemCount) return;
    TableItem [] children = items;
    if (count < itemCount) {
        for (int index = count; index < itemCount; index ++) {
            TableItem item = children [index];
            if (item !is null && !item.isDisposed()) item.release (false);
        }
    }
    if (count > itemCount) {
        if ((getStyle() & DWT.VIRTUAL) is 0) {
            for (int i=itemCount; i<count; i++) {
                new TableItem (this, DWT.NONE, i, true);
            }
            return;
        }
    }
    int length = Math.max (4, (count + 3) / 4 * 4);
    TableItem [] newItems = new TableItem [length];
    if (children !is null) {
        System.arraycopy (items, 0, newItems, 0, Math.min (count, itemCount));
    }
    children = newItems;
    this.items = newItems;
    this.itemCount = count;
    (cast(NSTableView) view).noteNumberOfRowsChanged ();
}

/*public*/ void setItemHeight (int itemHeight) {
    checkWidget ();
    if (itemHeight < -1) error (DWT.ERROR_INVALID_ARGUMENT);
    if (itemHeight is -1) {
        //TODO - reset item height, ensure other API's such as setFont don't do this
    } else {
        (cast(NSTableView)view).setRowHeight (itemHeight);
    }
}

void setItemHeight (Image image, NSFont font, bool set) {
    if (font is null) font = getFont ().handle;
    Cocoa.CGFloat ascent = font.ascender ();
    Cocoa.CGFloat descent = -font.descender () + font.leading ();
    int height = cast(int)Math.ceil (ascent + descent) + 1;
    Rectangle bounds = image !is null ? image.getBounds () : imageBounds;
    if (bounds !is null) {
        imageBounds = bounds;
        height = Math.max (height, bounds.height);
    }
    NSTableView widget = cast(NSTableView)view;
    if (set || widget.rowHeight () < height) {
        widget.setRowHeight (height);
    }
}

public void setRedraw (bool redraw) {
    checkWidget ();
    super.setRedraw (redraw);
    if (redraw && drawCount is 0) {
        /* Resize the item array to match the item count */
        if (items.length > 4 && items.length - itemCount > 3) {
            int length = Math.max (4, (itemCount + 3) / 4 * 4);
            TableItem [] newItems = new TableItem [length];
            System.arraycopy (items, 0, newItems, 0, itemCount);
            items = newItems;
        }
        setScrollWidth ();
    }
}

/**
 * Marks the receiver's lines as visible if the argument is <code>true</code>,
 * and marks it invisible otherwise. Note that some platforms draw grid lines
 * while others may draw alternating row colors.
 * <p>
 * If one of the receiver's ancestors is not visible or some
 * other condition makes the receiver not visible, marking
 * it visible may not actually cause it to be displayed.
 * </p>
 *
 * @param show the new visibility state
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setLinesVisible (bool show) {
    checkWidget ();
    (cast(NSTableView)view).setUsesAlternatingRowBackgroundColors(show);
}

bool setScrollWidth () {
    return setScrollWidth (items, true);
}

bool setScrollWidth (TableItem item) {
    if (columnCount !is 0) return false;
    if (!getDrawing()) return false;
    if (currentItem !is null) {
        if (currentItem !is item) fixScrollWidth = true;
        return false;
    }
    GC gc = new GC (this);
    int newWidth = item.calculateWidth (0, gc);
    gc.dispose ();
    int oldWidth = cast(int)firstColumn.width ();
    if (oldWidth < newWidth) {
        firstColumn.setWidth (newWidth);
        if (horizontalBar !is null && horizontalBar.view !is null) redrawWidget (horizontalBar.view, false);
        return true;
    }
    return false;
}

bool setScrollWidth (TableItem [] items, bool set) {
    if (items is null) return false;
    if (columnCount !is 0) return false;
    if (!getDrawing()) return false;
    if (currentItem !is null) {
        fixScrollWidth = true;
        return false;
    }
    GC gc = new GC (this);
    int newWidth = 0;
    for (int i = 0; i < items.length; i++) {
        TableItem item = items [i];
        if (item !is null) {
            newWidth = Math.max (newWidth, item.calculateWidth (0, gc));
        }
    }
    gc.dispose ();
    if (!set) {
        int oldWidth = cast(int)firstColumn.width ();
        if (oldWidth >= newWidth) return false;
    }
    firstColumn.setWidth (newWidth);
    if (horizontalBar !is null && horizontalBar.view !is null) redrawWidget (horizontalBar.view, false);
    return true;
}

/**
 * Selects the item at the given zero-relative index in the receiver.
 * The current selection is first cleared, then the new item is selected.
 *
 * @param index the index of the item to select
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#deselectAll()
 * @see Table#select(int)
 */
public void setSelection (int index) {
    checkWidget ();
    //TODO - optimize to use expand flag
    deselectAll ();
    if (0 <= index && index < itemCount) {
        select (index);
        showIndex (index);
    }
}

/**
 * Selects the items in the range specified by the given zero-relative
 * indices in the receiver. The range of indices is inclusive.
 * The current selection is cleared before the new items are selected.
 * <p>
 * Indices that are out of range are ignored and no items will be selected
 * if start is greater than end.
 * If the receiver is single-select and there is more than one item in the
 * given range, then all indices are ignored.
 * </p>
 *
 * @param start the start index of the items to select
 * @param end the end index of the items to select
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#deselectAll()
 * @see Table#select(int,int)
 */
public void setSelection (int start, int end) {
    checkWidget ();
    //TODO - optimize to use expand flag
    deselectAll ();
    if (end < 0 || start > end || ((style & DWT.SINGLE) !is 0 && start !is end)) return;
    if (itemCount is 0 || start >= itemCount) return;
    start = Math.max (0, start);
    end = Math.min (end, itemCount - 1);
    select (start, end);
    showIndex (start);
}

/**
 * Selects the items at the given zero-relative indices in the receiver.
 * The current selection is cleared before the new items are selected.
 * <p>
 * Indices that are out of range and duplicate indices are ignored.
 * If the receiver is single-select and multiple indices are specified,
 * then all indices are ignored.
 * </p>
 *
 * @param indices the indices of the items to select
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the array of indices is null</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#deselectAll()
 * @see Table#select(int[])
 */
public void setSelection (int [] indices) {
    checkWidget ();
    if (indices is null) error (DWT.ERROR_NULL_ARGUMENT);
    //TODO - optimize to use expand flag
    deselectAll ();
    int length = indices.length;
    if (length is 0 || ((style & DWT.SINGLE) !is 0 && length > 1)) return;
    select (indices);
    showIndex (indices [0]);
}

/**
 * Sets the receiver's selection to the given item.
 * The current selection is cleared before the new item is selected.
 * <p>
 * If the item is not in the receiver, then it is ignored.
 * </p>
 *
 * @param item the item to select
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the item is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the item has been disposed</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.2
 */
public void setSelection (TableItem  item) {
    checkWidget ();
    if (item is null) error (DWT.ERROR_NULL_ARGUMENT);
    setSelection ([item]);
}

/**
 * Sets the receiver's selection to be the given array of items.
 * The current selection is cleared before the new items are selected.
 * <p>
 * Items that are not in the receiver are ignored.
 * If the receiver is single-select and multiple items are specified,
 * then all items are ignored.
 * </p>
 *
 * @param items the array of items
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the array of items is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if one of the items has been disposed</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#deselectAll()
 * @see Table#select(int[])
 * @see Table#setSelection(int[])
 */
public void setSelection (TableItem [] items) {
    checkWidget ();
    if (items is null) error (DWT.ERROR_NULL_ARGUMENT);
    //TODO - optimize to use expand flag
    deselectAll ();
    int length_ = items.length;
    if (length_ is 0 || ((style & DWT.SINGLE) !is 0 && length_ > 1)) return;
    int [] indices = new int [length_];
    int count = 0;
    for (int i=0; i<length_; i++) {
        int index = indexOf (items [length_ - i - 1]);
        if (index !is -1) {
            indices [count++] = index;
        }
    }
    if (count > 0) {
        select (indices);
        showIndex (indices [0]);
    }
}

void setSmallSize () {
    if (checkColumn is null) return;
    checkColumn.dataCell ().setControlSize (OS.NSSmallControlSize);
    checkColumn.setWidth (getCheckColumnWidth ());
}

/**
 * Sets the column used by the sort indicator for the receiver. A null
 * value will clear the sort indicator.  The current sort column is cleared
 * before the new column is set.
 *
 * @param column the column used by the sort indicator or <code>null</code>
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_ARGUMENT - if the column is disposed</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.2
 */
public void setSortColumn (TableColumn column) {
    checkWidget ();
    if (column !is null && column.isDisposed ()) error (DWT.ERROR_INVALID_ARGUMENT);
    if (column is sortColumn) return;
    sortColumn = column;
    (cast(NSTableView)view).setHighlightedTableColumn (column is null ? null : column.nsColumn);
}

/**
 * Sets the direction of the sort indicator for the receiver. The value
 * can be one of <code>UP</code>, <code>DOWN</code> or <code>NONE</code>.
 *
 * @param direction the direction of the sort indicator
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.2
 */
public void setSortDirection  (int direction) {
    checkWidget ();
    if (direction !is DWT.UP && direction !is DWT.DOWN && direction !is DWT.NONE) return;
    if (direction is sortDirection) return;
    sortDirection = direction;
    if (sortColumn is null) return;
    NSTableHeaderView headerView = (cast(NSTableView)view).headerView ();
    if (headerView is null) return;
    int index = indexOf (sortColumn.nsColumn);
    NSRect rect = headerView.headerRectOfColumn (index);
    headerView.setNeedsDisplayInRect (rect);
}

void setTableEmpty () {
    itemCount = 0;
    items = new TableItem [4];
    imageBounds = null;
}

/**
 * Sets the zero-relative index of the item which is currently
 * at the top of the receiver. This index can change when items
 * are scrolled or new items are added and removed.
 *
 * @param index the index of the top item
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 */
public void setTopIndex (int index) {
    checkWidget ();
    NSTableView widget = cast(NSTableView) view;
    int row = Math.max(0, Math.min(index, itemCount));
    NSPoint pt = NSPoint();
    pt.x = scrollView.contentView().bounds().x;
    pt.y = widget.frameOfCellAtColumn(0, row).y;
    view.scrollPoint(pt);
}

/**
 * Shows the column.  If the column is already showing in the receiver,
 * this method simply returns.  Otherwise, the columns are scrolled until
 * the column is visible.
 *
 * @param column the column to be shown
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the column is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the column has been disposed</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @since 3.0
 */
public void showColumn (TableColumn column) {
    checkWidget ();
    if (column is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (column.isDisposed()) error(DWT.ERROR_INVALID_ARGUMENT);
    if (column.parent !is this) return;
    if (columnCount <= 1) return;
    int index = indexOf (column.nsColumn);
    if (!(0 <= index && index < columnCount + ((style & DWT.CHECK) !is 0 ? 1 : 0))) return;
    (cast(NSTableView)view).scrollColumnToVisible (index);
}

void showIndex (int index) {
    if (0 <= index && index < itemCount) {
        (cast(NSTableView)view).scrollRowToVisible(index);
    }
}

/**
 * Shows the item.  If the item is already showing in the receiver,
 * this method simply returns.  Otherwise, the items are scrolled until
 * the item is visible.
 *
 * @param item the item to be shown
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the item is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the item has been disposed</li>
 * </ul>
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#showSelection()
 */
public void showItem (TableItem item) {
    checkWidget ();
    if (item is null) error (DWT.ERROR_NULL_ARGUMENT);
    if (item.isDisposed()) error(DWT.ERROR_INVALID_ARGUMENT);
    int index = indexOf (item);
    if (index !is -1) showIndex (index);
}

/**
 * Shows the selection.  If the selection is already showing in the receiver,
 * this method simply returns.  Otherwise, the items are scrolled until
 * the selection is visible.
 *
 * @exception DWTException <ul>
 *    <li>ERROR_WIDGET_DISPOSED - if the receiver has been disposed</li>
 *    <li>ERROR_THREAD_INVALID_ACCESS - if not called from the thread that created the receiver</li>
 * </ul>
 *
 * @see Table#showItem(TableItem)
 */
public void showSelection () {
    checkWidget ();
    int index = getSelectionIndex ();
    if (index >= 0) {
        checkData(_getItem(index));
        showIndex (index);
    }
}

void sendDoubleSelection() {
    NSTableView tableView = cast(NSTableView)view;
    NSInteger rowIndex = tableView.clickedRow ();
    if (rowIndex !is -1) {
        if ((style & DWT.CHECK) !is 0) {
            NSArray columns = tableView.tableColumns ();
            NSInteger columnIndex = tableView.clickedColumn ();
            cocoa.id column = columns.objectAtIndex (columnIndex);
            if (column.id is checkColumn.id) return;
        }
        Event event = new Event ();
        event.item = _getItem (rowIndex);
        postEvent (DWT.DefaultSelection, event);
    }
}

bool sendKeyEvent (NSEvent nsEvent, int type) {
    bool result = super.sendKeyEvent (nsEvent, type);
    if (!result) return result;
    if (type !is DWT.KeyDown) return result;
    ushort keyCode = nsEvent.keyCode ();
    switch (keyCode) {
        case 76: /* KP Enter */
        case 36: { /* Return */
            postEvent (DWT.DefaultSelection);
            break;
        }
        default:
    }
    return result;
}

void sendMeasureItem (TableItem item, int columnIndex, NSSize size) {
    NSTableView widget = cast(NSTableView)this.view;
    int contentWidth = cast(int)Math.ceil (size.width);
    NSSize spacing = widget.intercellSpacing();
    int itemHeight = cast(int)Math.ceil (widget.rowHeight() + spacing.height);
    GCData data = new GCData ();
    data.paintRectStruct = widget.frame ();
    data.paintRect = &data.paintRectStruct;
    GC gc = GC.cocoa_new (this, data);
    gc.setFont (item.getFont (columnIndex));
    Event event = new Event ();
    event.item = item;
    event.gc = gc;
    event.index = columnIndex;
    event.width = contentWidth;
    event.height = itemHeight;
    sendEvent (DWT.MeasureItem, event);
    gc.dispose ();
    if (!isDisposed () && !item.isDisposed ()) {
        size.width = event.width;
        size.height = event.height;
        if (itemHeight < event.height) {
            widget.setRowHeight (event.height);
        }
        if (contentWidth !is event.width) {
            if (columnCount is 0 && columnIndex is 0) {
                item.width = event.width;
                if (setScrollWidth (item)) {
                    widget.setNeedsDisplay(true);
                }
            }
        }
    }
}

void tableViewColumnDidMove (objc.id id, objc.SEL sel, objc.id aNotification) {
    NSNotification notification = new NSNotification (aNotification);
    NSDictionary userInfo = notification.userInfo ();
    cocoa.id nsOldIndex = userInfo.valueForKey (NSString.stringWith ("NSOldColumn")); //$NON-NLS-1$
    cocoa.id nsNewIndex = userInfo.valueForKey (NSString.stringWith ("NSNewColumn")); //$NON-NLS-1$
    int oldIndex = (new NSNumber (nsOldIndex)).intValue ();
    int newIndex = (new NSNumber (nsNewIndex)).intValue ();
    int startIndex = Math.min (oldIndex, newIndex);
    int endIndex = Math.max (oldIndex, newIndex);
    NSTableView tableView = cast(NSTableView)view;
    NSArray nsColumns = tableView.tableColumns ();
    for (int i = startIndex; i <= endIndex; i++) {
        cocoa.id columnId = nsColumns.objectAtIndex (i);
        TableColumn column = getColumn (columnId);
        if (column !is null) {
            column.sendEvent (DWT.Move);
            if (isDisposed ()) return;
        }
    }
}

void tableViewColumnDidResize (objc.id id, objc.SEL sel, objc.id aNotification) {
    NSNotification notification = new NSNotification (aNotification);
    NSDictionary userInfo = notification.userInfo ();
    cocoa.id columnId = userInfo.valueForKey (NSString.stringWith ("NSTableColumn")); //$NON-NLS-1$
    TableColumn column = getColumn (columnId);
    if (column is null) return; /* either CHECK column or firstColumn in 0-column Table */

    column.sendEvent (DWT.Resize);
    if (isDisposed ()) return;

    NSTableView tableView = cast(NSTableView)view;
    int index = indexOf (column.nsColumn);
    if (index is -1) return; /* column was disposed in Resize callback */

    NSArray nsColumns = tableView.tableColumns ();
    int columnCount = cast(int)/*64*/tableView.numberOfColumns ();
    for (int i = index + 1; i < columnCount; i++) {
        columnId = nsColumns.objectAtIndex (i);
        column = getColumn (columnId);
        if (column !is null) {
            column.sendEvent (DWT.Move);
            if (isDisposed ()) return;
        }
    }
}

void tableViewSelectionDidChange (objc.id id, objc.SEL sel, objc.id aNotification) {
    if (ignoreSelect) return;
    NSTableView widget = cast(NSTableView) view;
    NSInteger row = widget.selectedRow ();
    if(row is -1)
        postEvent (DWT.Selection);
    else {
        TableItem item = _getItem (row);
        Event event = new Event ();
        event.item = item;
        event.index = row;
        postEvent (DWT.Selection, event);
    }
}

void tableView_didClickTableColumn (objc.id id, objc.SEL sel, objc.id tableView, objc.id tableColumn) {
    TableColumn column = getColumn (new cocoa.id (tableColumn));
    if (column is null) return; /* either CHECK column or firstColumn in 0-column Table */
    column.postEvent (DWT.Selection);
}

objc.id tableView_objectValueForTableColumn_row (objc.id id, objc.SEL sel, objc.id aTableView, objc.id aTableColumn, objc.id rowIndex) {
    int index = cast(NSInteger)rowIndex;
    TableItem item = _getItem (index);
    checkData (item, index);
    if (checkColumn !is null && aTableColumn is checkColumn.id) {
        NSNumber value;
        if (item.checked && item.grayed) {
            value = NSNumber.numberWithInt (OS.NSMixedState);
        } else {
            value = NSNumber.numberWithInt (item.checked ? OS.NSOnState : OS.NSOffState);
        }
        return value.id;
    }
    for (int i=0; i<columnCount; i++) {
        if (columns [i].nsColumn.id is aTableColumn) {
            return item.createString (i).id;
        }
    }
    return item.createString (0).id;
}

void tableView_setObjectValue_forTableColumn_row (objc.id id, objc.SEL sel, objc.id aTableView, objc.id anObject, objc.id aTableColumn, objc.id rowIndex) {
    if (checkColumn !is null && aTableColumn is checkColumn.id)  {
        TableItem item = items [cast(NSInteger)rowIndex];
        item.checked = !item.checked;
        Event event = new Event ();
        event.detail = DWT.CHECK;
        event.item = item;
        event.index = cast(int)/*64*/rowIndex;
        postEvent (DWT.Selection, event);
        item.redraw (-1);
    }
}

bool tableView_shouldEditTableColumn_row (objc.id id, objc.SEL sel, objc.id aTableView, objc.id aTableColumn, objc.id rowIndex) {
    return false;
}

void tableView_willDisplayCell_forTableColumn_row (objc.id id, objc.SEL sel, objc.id aTableView, objc.id cell, objc.id tableColumn, objc.id rowIndex) {
    if (checkColumn !is null && tableColumn is checkColumn.id) return;
    TableItem item = items [cast(NSInteger)rowIndex];
    int index = 0;
    for (int i=0; i<columnCount; i++) {
        if (columns [i].nsColumn.id is tableColumn) {
            index = i;
            break;
        }
    }
    NSTextFieldCell textCell = new NSTextFieldCell (cell);
    OS.object_setInstanceVariable(cell, Display.SWT_ROW, rowIndex);
    OS.object_setInstanceVariable(cell, Display.SWT_COLUMN, tableColumn);
    Image image = index is 0 ? item.image : (item.images is null ? null : item.images [index]);
    textCell.setImage (image !is null ? image.handle : null);
    NSColor color;
    if (textCell.isEnabled()) {
        if (textCell.isHighlighted()) {
            color = NSColor.selectedControlTextColor();
        } else {
            Color foreground = item.cellForeground !is null ? item.cellForeground [index] : null;
            if (foreground is null) foreground = item.foreground;
            if (foreground is null) foreground = getForegroundColor();
            color = NSColor.colorWithDeviceRed (foreground.handle [0], foreground.handle [1], foreground.handle [2], 1);
        }
    } else {
        color = NSColor.disabledControlTextColor();
    }
    int alignment = OS.NSLeftTextAlignment;
    if (columnCount > 0) {
        int style = columns [index].style;
        if ((style & DWT.CENTER) !is 0) {
            alignment = OS.NSCenterTextAlignment;
        } else if ((style & DWT.RIGHT) !is 0) {
            alignment = OS.NSRightTextAlignment;
        }
    }
    Font font = item.cellFont !is null ? item.cellFont [index] : null;
    if (font is null) font = item.font;
    if (font is null) font = this.font;
    if (font is null) font = defaultFont ();
    if (font.extraTraits !is 0) {
        NSMutableDictionary dict = (cast(NSMutableDictionary)(new NSMutableDictionary()).alloc()).initWithCapacity(5);
        dict.setObject (color, OS.NSForegroundColorAttributeName);
        dict.setObject (font.handle, OS.NSFontAttributeName);
        addTraits(dict, font);
        NSMutableParagraphStyle paragraphStyle = cast(NSMutableParagraphStyle)(new NSMutableParagraphStyle ()).alloc ().init ();
        paragraphStyle.setLineBreakMode (OS.NSLineBreakByClipping);
        paragraphStyle.setAlignment (cast(NSTextAlignment)alignment);
        dict.setObject (paragraphStyle, OS.NSParagraphStyleAttributeName);
        paragraphStyle.release ();
        NSAttributedString attribStr = (cast(NSAttributedString) (new NSAttributedString ()).alloc ()).initWithString (textCell.title(), dict);
        textCell.setAttributedStringValue(attribStr);
        attribStr.release();
        dict.release();
    } else {
        textCell.setFont(font.handle);
        textCell.setTextColor(color);
        textCell.setAlignment (cast(NSTextAlignment)alignment);
    }
}

bool tableView_writeRowsWithIndexes_toPasteboard(objc.id id, objc.SEL sel, objc.id arg0, objc.id arg1, objc.id arg2) {
    return sendMouseEvent(NSApplication.sharedApplication().currentEvent(), DWT.DragDetect, true);
}

NSRect titleRectForBounds (objc.id id, objc.SEL sel, NSRect cellFrame) {
    NSImage image = (new NSCell(id)).image();
    if (image !is null) {
        int imageWidth = imageBounds.width + IMAGE_GAP;
        cellFrame.x = cellFrame.x + imageWidth;
        cellFrame.width = cellFrame.width - imageWidth;
    }
    return cellFrame;
}

void updateCursorRects (bool enabled) {
    updateCursorRects (enabled);
    if (headerView is null) return;
    updateCursorRects (enabled, headerView);
}
}
