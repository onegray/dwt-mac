#!/bin/sh

if [[ -s "$HOME/.dvm/scripts/dvm" ]] ; then
	. "$HOME/.dvm/scripts/dvm"
	dvm use 1.072
fi

rdmd --build-only -gc -debug -L-framework -LCocoa -L-framework -LCarbon -Jres -ofmain -I. main.d

# dmd -gc -debug -L-framework -LCocoa -L-framework -LCarbon -Jres -ofmain -I. main.d \
# dwt/accessibility/ACC.d \
# dwt/accessibility/Accessible.d \
# dwt/accessibility/AccessibleAdapter.d \
# dwt/accessibility/AccessibleControlAdapter.d \
# dwt/accessibility/AccessibleControlEvent.d \
# dwt/accessibility/AccessibleControlListener.d \
# dwt/accessibility/AccessibleEvent.d \
# dwt/accessibility/AccessibleListener.d \
# dwt/accessibility/AccessibleTextAdapter.d \
# dwt/accessibility/AccessibleTextEvent.d \
# dwt/accessibility/AccessibleTextListener.d \
# dwt/accessibility/all.d \
# dwt/accessibility/SWTAccessibleDelegate.d \
# dwt/all.d \
# dwt/custom/all.d \
# dwt/custom/AnimatedProgress.d \
# dwt/custom/BidiSegmentEvent.d \
# dwt/custom/BidiSegmentListener.d \
# dwt/custom/Bullet.d \
# dwt/custom/BusyIndicator.d \
# dwt/custom/CaretEvent.d \
# dwt/custom/CaretListener.d \
# dwt/custom/CBanner.d \
# dwt/custom/CBannerLayout.d \
# dwt/custom/CCombo.d \
# dwt/custom/CLabel.d \
# dwt/custom/CLayoutData.d \
# dwt/custom/ControlEditor.d \
# dwt/custom/CTabFolder.d \
# dwt/custom/CTabFolder2Adapter.d \
# dwt/custom/CTabFolder2Listener.d \
# dwt/custom/CTabFolderAdapter.d \
# dwt/custom/CTabFolderEvent.d \
# dwt/custom/CTabFolderLayout.d \
# dwt/custom/CTabFolderListener.d \
# dwt/custom/CTabItem.d \
# dwt/custom/DefaultContent.d \
# dwt/custom/ExtendedModifyEvent.d \
# dwt/custom/ExtendedModifyListener.d \
# dwt/custom/LineBackgroundEvent.d \
# dwt/custom/LineBackgroundListener.d \
# dwt/custom/LineStyleEvent.d \
# dwt/custom/LineStyleListener.d \
# dwt/custom/MovementEvent.d \
# dwt/custom/MovementListener.d \
# dwt/custom/PaintObjectEvent.d \
# dwt/custom/PaintObjectListener.d \
# dwt/custom/PopupList.d \
# dwt/custom/SashForm.d \
# dwt/custom/SashFormData.d \
# dwt/custom/SashFormLayout.d \
# dwt/custom/ScrolledComposite.d \
# dwt/custom/ScrolledCompositeLayout.d \
# dwt/custom/ST.d \
# dwt/custom/StackLayout.d \
# dwt/custom/StyledText.d \
# dwt/custom/StyledTextContent.d \
# dwt/custom/StyledTextDropTargetEffect.d \
# dwt/custom/StyledTextEvent.d \
# dwt/custom/StyledTextListener.d \
# dwt/custom/StyledTextPrintOptions.d \
# dwt/custom/StyledTextRenderer.d \
# dwt/custom/StyleRange.d \
# dwt/custom/TableCursor.d \
# dwt/custom/TableEditor.d \
# dwt/custom/TableTree.d \
# dwt/custom/TableTreeEditor.d \
# dwt/custom/TableTreeItem.d \
# dwt/custom/TextChangedEvent.d \
# dwt/custom/TextChangeListener.d \
# dwt/custom/TextChangingEvent.d \
# dwt/custom/TreeEditor.d \
# dwt/custom/VerifyKeyListener.d \
# dwt/custom/ViewForm.d \
# dwt/custom/ViewFormLayout.d \
# dwt/dnd/all.d \
# dwt/dnd/ByteArrayTransfer.d \
# dwt/dnd/Clipboard.d \
# dwt/dnd/DND.d \
# dwt/dnd/DNDEvent.d \
# dwt/dnd/DNDListener.d \
# dwt/dnd/DragSource.d \
# dwt/dnd/DragSourceAdapter.d \
# dwt/dnd/DragSourceEffect.d \
# dwt/dnd/DragSourceEvent.d \
# dwt/dnd/DragSourceListener.d \
# dwt/dnd/DropTarget.d \
# dwt/dnd/DropTargetAdapter.d \
# dwt/dnd/DropTargetEffect.d \
# dwt/dnd/DropTargetEvent.d \
# dwt/dnd/DropTargetListener.d \
# dwt/dnd/FileTransfer.d \
# dwt/dnd/HTMLTransfer.d \
# dwt/dnd/ImageTransfer.d \
# dwt/dnd/RTFTransfer.d \
# dwt/dnd/TableDragSourceEffect.d \
# dwt/dnd/TableDropTargetEffect.d \
# dwt/dnd/TextTransfer.d \
# dwt/dnd/Transfer.d \
# dwt/dnd/TransferData.d \
# dwt/dnd/TreeDragSourceEffect.d \
# dwt/dnd/TreeDropTargetEffect.d \
# dwt/dnd/URLTransfer.d \
# dwt/DWT.d \
# dwt/DWTError.d \
# dwt/DWTException.d \
# dwt/dwthelper/all.d \
# dwt/dwthelper/array.d \
# dwt/dwthelper/associativearray.d \
# dwt/dwthelper/BufferedInputStream.d \
# dwt/dwthelper/BufferedOutputStream.d \
# dwt/dwthelper/ByteArrayInputStream.d \
# dwt/dwthelper/ByteArrayOutputStream.d \
# dwt/dwthelper/File.d \
# dwt/dwthelper/FileInputStream.d \
# dwt/dwthelper/FileOutputStream.d \
# dwt/dwthelper/InflaterInputStream.d \
# dwt/dwthelper/InputStream.d \
# dwt/dwthelper/OutputStream.d \
# dwt/dwthelper/ResourceBundle.d \
# dwt/dwthelper/Runnable.d \
# dwt/dwthelper/System.d \
# dwt/dwthelper/utils.d \
# dwt/dwthelper/WeakHashMap.d \
# dwt/dwthelper/WeakRef.d \
# dwt/dwthelper/XmlTranscode.d \
# dwt/events/all.d \
# dwt/events/ArmEvent.d \
# dwt/events/ArmListener.d \
# dwt/events/ControlAdapter.d \
# dwt/events/ControlEvent.d \
# dwt/events/ControlListener.d \
# dwt/events/DisposeEvent.d \
# dwt/events/DisposeListener.d \
# dwt/events/DragDetectEvent.d \
# dwt/events/DragDetectListener.d \
# dwt/events/ExpandAdapter.d \
# dwt/events/ExpandEvent.d \
# dwt/events/ExpandListener.d \
# dwt/events/FocusAdapter.d \
# dwt/events/FocusEvent.d \
# dwt/events/FocusListener.d \
# dwt/events/HelpEvent.d \
# dwt/events/HelpListener.d \
# dwt/events/KeyAdapter.d \
# dwt/events/KeyEvent.d \
# dwt/events/KeyListener.d \
# dwt/events/MenuAdapter.d \
# dwt/events/MenuDetectEvent.d \
# dwt/events/MenuDetectListener.d \
# dwt/events/MenuEvent.d \
# dwt/events/MenuListener.d \
# dwt/events/ModifyEvent.d \
# dwt/events/ModifyListener.d \
# dwt/events/MouseAdapter.d \
# dwt/events/MouseEvent.d \
# dwt/events/MouseListener.d \
# dwt/events/MouseMoveListener.d \
# dwt/events/MouseTrackAdapter.d \
# dwt/events/MouseTrackListener.d \
# dwt/events/MouseWheelListener.d \
# dwt/events/PaintEvent.d \
# dwt/events/PaintListener.d \
# dwt/events/SelectionAdapter.d \
# dwt/events/SelectionEvent.d \
# dwt/events/SelectionListener.d \
# dwt/events/ShellAdapter.d \
# dwt/events/ShellEvent.d \
# dwt/events/ShellListener.d \
# dwt/events/TraverseEvent.d \
# dwt/events/TraverseListener.d \
# dwt/events/TreeAdapter.d \
# dwt/events/TreeEvent.d \
# dwt/events/TreeListener.d \
# dwt/events/TypedEvent.d \
# dwt/events/VerifyEvent.d \
# dwt/events/VerifyListener.d \
# dwt/graphics/all.d \
# dwt/graphics/Color.d \
# dwt/graphics/Cursor.d \
# dwt/graphics/Device.d \
# dwt/graphics/DeviceData.d \
# dwt/graphics/Drawable.d \
# dwt/graphics/Font.d \
# dwt/graphics/FontData.d \
# dwt/graphics/FontMetrics.d \
# dwt/graphics/GC.d \
# dwt/graphics/GCData.d \
# dwt/graphics/GlyphMetrics.d \
# dwt/graphics/Image.d \
# dwt/graphics/ImageData.d \
# dwt/graphics/ImageDataLoader.d \
# dwt/graphics/ImageLoader.d \
# dwt/graphics/ImageLoaderEvent.d \
# dwt/graphics/ImageLoaderListener.d \
# dwt/graphics/LineAttributes.d \
# dwt/graphics/PaletteData.d \
# dwt/graphics/Path.d \
# dwt/graphics/PathData.d \
# dwt/graphics/Pattern.d \
# dwt/graphics/Point.d \
# dwt/graphics/Rectangle.d \
# dwt/graphics/Region.d \
# dwt/graphics/Resource.d \
# dwt/graphics/RGB.d \
# dwt/graphics/TextLayout.d \
# dwt/graphics/TextStyle.d \
# dwt/graphics/Transform.d \
# dwt/internal/BidiUtil.d \
# dwt/internal/c/bindings.d \
# dwt/internal/c/Carbon.d \
# dwt/internal/c/custom.d \
# dwt/internal/C.d \
# dwt/internal/CloneableCompatibility.d \
# dwt/internal/cocoa/CGPathElement.d \
# dwt/internal/cocoa/CGPoint.d \
# dwt/internal/cocoa/CGRect.d \
# dwt/internal/cocoa/CGSize.d \
# dwt/internal/cocoa/DOMDocument.d \
# dwt/internal/cocoa/DOMEvent.d \
# dwt/internal/cocoa/DOMKeyboardEvent.d \
# dwt/internal/cocoa/DOMMouseEvent.d \
# dwt/internal/cocoa/DOMUIEvent.d \
# dwt/internal/cocoa/DOMWheelEvent.d \
# dwt/internal/cocoa/id.d \
# dwt/internal/cocoa/IOLLEvent.d \
# dwt/internal/cocoa/NSActionCell.d \
# dwt/internal/cocoa/NSAffineTransform.d \
# dwt/internal/cocoa/NSAffineTransformStruct.d \
# dwt/internal/cocoa/NSAlert.d \
# dwt/internal/cocoa/NSAppleEventDescriptor.d \
# dwt/internal/cocoa/NSApplication.d \
# dwt/internal/cocoa/NSArray.d \
# dwt/internal/cocoa/NSAttributedString.d \
# dwt/internal/cocoa/NSAttributeType.d \
# dwt/internal/cocoa/NSAutoreleasePool.d \
# dwt/internal/cocoa/NSBezierPath.d \
# dwt/internal/cocoa/NSBitmapImageRep.d \
# dwt/internal/cocoa/NSBox.d \
# dwt/internal/cocoa/NSBrowserCell.d \
# dwt/internal/cocoa/NSBundle.d \
# dwt/internal/cocoa/NSButton.d \
# dwt/internal/cocoa/NSButtonCell.d \
# dwt/internal/cocoa/NSCalendarDate.d \
# dwt/internal/cocoa/NSCell.d \
# dwt/internal/cocoa/NSCharacterSet.d \
# dwt/internal/cocoa/NSClipView.d \
# dwt/internal/cocoa/NSCoder.d \
# dwt/internal/cocoa/NSColor.d \
# dwt/internal/cocoa/NSColorPanel.d \
# dwt/internal/cocoa/NSColorSpace.d \
# dwt/internal/cocoa/NSComboBox.d \
# dwt/internal/cocoa/NSComboBoxCell.d \
# dwt/internal/cocoa/NSComparisonResult.d \
# dwt/internal/cocoa/NSControl.d \
# dwt/internal/cocoa/NSCursor.d \
# dwt/internal/cocoa/NSData.d \
# dwt/internal/cocoa/NSDate.d \
# dwt/internal/cocoa/NSDatePicker.d \
# dwt/internal/cocoa/NSDictionary.d \
# dwt/internal/cocoa/NSDirectoryEnumerator.d \
# dwt/internal/cocoa/NSDragOperation.d \
# dwt/internal/cocoa/NSEnumerator.d \
# dwt/internal/cocoa/NSError.d \
# dwt/internal/cocoa/NSEvent.d \
# dwt/internal/cocoa/NSFileManager.d \
# dwt/internal/cocoa/NSFileWrapper.d \
# dwt/internal/cocoa/NSFocusRingType.d \
# dwt/internal/cocoa/NSFont.d \
# dwt/internal/cocoa/NSFontManager.d \
# dwt/internal/cocoa/NSFontPanel.d \
# dwt/internal/cocoa/NSFormatter.d \
# dwt/internal/cocoa/NSGradient.d \
# dwt/internal/cocoa/NSGraphicsContext.d \
# dwt/internal/cocoa/NSHTTPCookie.d \
# dwt/internal/cocoa/NSHTTPCookieStorage.d \
# dwt/internal/cocoa/NSImage.d \
# dwt/internal/cocoa/NSImageCell.d \
# dwt/internal/cocoa/NSImageRep.d \
# dwt/internal/cocoa/NSImageView.d \
# dwt/internal/cocoa/NSIndexSet.d \
# dwt/internal/cocoa/NSInputManager.d \
# dwt/internal/cocoa/NSInterfaceStyle.d \
# dwt/internal/cocoa/NSKeyedArchiver.d \
# dwt/internal/cocoa/NSKeyedUnarchiver.d \
# dwt/internal/cocoa/NSLayoutManager.d \
# dwt/internal/cocoa/NSMenu.d \
# dwt/internal/cocoa/NSMenuItem.d \
# dwt/internal/cocoa/NSMutableArray.d \
# dwt/internal/cocoa/NSMutableAttributedString.d \
# dwt/internal/cocoa/NSMutableDictionary.d \
# dwt/internal/cocoa/NSMutableIndexSet.d \
# dwt/internal/cocoa/NSMutableParagraphStyle.d \
# dwt/internal/cocoa/NSMutableSet.d \
# dwt/internal/cocoa/NSMutableString.d \
# dwt/internal/cocoa/NSMutableURLRequest.d \
# dwt/internal/cocoa/NSNotification.d \
# dwt/internal/cocoa/NSNotificationCenter.d \
# dwt/internal/cocoa/NSNumber.d \
# dwt/internal/cocoa/NSNumberFormatter.d \
# dwt/internal/cocoa/NSObject.d \
# dwt/internal/cocoa/NSOpenGLContext.d \
# dwt/internal/cocoa/NSOpenGLPixelFormat.d \
# dwt/internal/cocoa/NSOpenGLView.d \
# dwt/internal/cocoa/NSOpenPanel.d \
# dwt/internal/cocoa/NSOutlineView.d \
# dwt/internal/cocoa/NSPanel.d \
# dwt/internal/cocoa/NSParagraphStyle.d \
# dwt/internal/cocoa/NSPasteboard.d \
# dwt/internal/cocoa/NSPoint.d \
# dwt/internal/cocoa/NSPopUpButton.d \
# dwt/internal/cocoa/NSPrinter.d \
# dwt/internal/cocoa/NSPrintInfo.d \
# dwt/internal/cocoa/NSPrintOperation.d \
# dwt/internal/cocoa/NSPrintPanel.d \
# dwt/internal/cocoa/NSProgressIndicator.d \
# dwt/internal/cocoa/NSRange.d \
# dwt/internal/cocoa/NSRect.d \
# dwt/internal/cocoa/NSResponder.d \
# dwt/internal/cocoa/NSRunLoop.d \
# dwt/internal/cocoa/NSSavePanel.d \
# dwt/internal/cocoa/NSScreen.d \
# dwt/internal/cocoa/NSScroller.d \
# dwt/internal/cocoa/NSScrollView.d \
# dwt/internal/cocoa/NSSearchField.d \
# dwt/internal/cocoa/NSSearchFieldCell.d \
# dwt/internal/cocoa/NSSecureTextField.d \
# dwt/internal/cocoa/NSSegmentedCell.d \
# dwt/internal/cocoa/NSSet.d \
# dwt/internal/cocoa/NSSize.d \
# dwt/internal/cocoa/NSSlider.d \
# dwt/internal/cocoa/NSStatusBar.d \
# dwt/internal/cocoa/NSStatusItem.d \
# dwt/internal/cocoa/NSStepper.d \
# dwt/internal/cocoa/NSString.d \
# dwt/internal/cocoa/NSTableColumn.d \
# dwt/internal/cocoa/NSTableHeaderCell.d \
# dwt/internal/cocoa/NSTableHeaderView.d \
# dwt/internal/cocoa/NSTableView.d \
# dwt/internal/cocoa/NSTabView.d \
# dwt/internal/cocoa/NSTabViewItem.d \
# dwt/internal/cocoa/NSText.d \
# dwt/internal/cocoa/NSTextAttachment.d \
# dwt/internal/cocoa/NSTextContainer.d \
# dwt/internal/cocoa/NSTextField.d \
# dwt/internal/cocoa/NSTextFieldCell.d \
# dwt/internal/cocoa/NSTextStorage.d \
# dwt/internal/cocoa/NSTextTab.d \
# dwt/internal/cocoa/NSTextView.d \
# dwt/internal/cocoa/NSThread.d \
# dwt/internal/cocoa/NSTimer.d \
# dwt/internal/cocoa/NSTimeZone.d \
# dwt/internal/cocoa/NSToolbar.d \
# dwt/internal/cocoa/NSToolbarItem.d \
# dwt/internal/cocoa/NSTrackingArea.d \
# dwt/internal/cocoa/NSTypesetter.d \
# dwt/internal/cocoa/NSURL.d \
# dwt/internal/cocoa/NSURLAuthenticationChallenge.d \
# dwt/internal/cocoa/NSURLCredential.d \
# dwt/internal/cocoa/NSURLDownload.d \
# dwt/internal/cocoa/NSURLProtectionSpace.d \
# dwt/internal/cocoa/NSURLRequest.d \
# dwt/internal/cocoa/NSValue.d \
# dwt/internal/cocoa/NSView.d \
# dwt/internal/cocoa/NSWindow.d \
# dwt/internal/cocoa/NSWorkspace.d \
# dwt/internal/cocoa/objc_super.d \
# dwt/internal/cocoa/OS.d \
# dwt/internal/cocoa/Protocol.d \
# dwt/internal/cocoa/SWTApplicationDelegate.d \
# dwt/internal/cocoa/SWTBox.d \
# dwt/internal/cocoa/SWTButton.d \
# dwt/internal/cocoa/SWTButtonCell.d \
# dwt/internal/cocoa/SWTCanvasView.d \
# dwt/internal/cocoa/SWTComboBox.d \
# dwt/internal/cocoa/SWTDatePicker.d \
# dwt/internal/cocoa/SWTDragSourceDelegate.d \
# dwt/internal/cocoa/SWTImageTextCell.d \
# dwt/internal/cocoa/SWTImageView.d \
# dwt/internal/cocoa/SWTMenu.d \
# dwt/internal/cocoa/SWTMenuItem.d \
# dwt/internal/cocoa/SWTOutlineView.d \
# dwt/internal/cocoa/SWTPanelDelegate.d \
# dwt/internal/cocoa/SWTPopUpButton.d \
# dwt/internal/cocoa/SWTPrinterView.d \
# dwt/internal/cocoa/SWTPrintPanelDelegate.d \
# dwt/internal/cocoa/SWTProgressIndicator.d \
# dwt/internal/cocoa/SWTScroller.d \
# dwt/internal/cocoa/SWTScrollView.d \
# dwt/internal/cocoa/SWTSearchField.d \
# dwt/internal/cocoa/SWTSecureTextField.d \
# dwt/internal/cocoa/SWTSlider.d \
# dwt/internal/cocoa/SWTStepper.d \
# dwt/internal/cocoa/SWTTableHeaderCell.d \
# dwt/internal/cocoa/SWTTableHeaderView.d \
# dwt/internal/cocoa/SWTTableView.d \
# dwt/internal/cocoa/SWTTabView.d \
# dwt/internal/cocoa/SWTTextField.d \
# dwt/internal/cocoa/SWTTextView.d \
# dwt/internal/cocoa/SWTToolbar.d \
# dwt/internal/cocoa/SWTTreeItem.d \
# dwt/internal/cocoa/SWTView.d \
# dwt/internal/cocoa/SWTWebViewDelegate.d \
# dwt/internal/cocoa/SWTWindow.d \
# dwt/internal/cocoa/SWTWindowDelegate.d \
# dwt/internal/cocoa/WebDataSource.d \
# dwt/internal/cocoa/WebDocumentRepresentation.d \
# dwt/internal/cocoa/WebFrame.d \
# dwt/internal/cocoa/WebFrameView.d \
# dwt/internal/cocoa/WebOpenPanelResultListener.d \
# dwt/internal/cocoa/WebPolicyDecisionListener.d \
# dwt/internal/cocoa/WebPreferences.d \
# dwt/internal/cocoa/WebScriptObject.d \
# dwt/internal/cocoa/WebUndefined.d \
# dwt/internal/cocoa/WebView.d \
# dwt/internal/Compatibility.d \
# dwt/internal/image/FileFormat.d \
# dwt/internal/image/GIFFileFormat.d \
# dwt/internal/image/JPEGAppn.d \
# dwt/internal/image/JPEGArithmeticConditioningTable.d \
# dwt/internal/image/JPEGComment.d \
# dwt/internal/image/JPEGDecoder.d \
# dwt/internal/image/JPEGEndOfImage.d \
# dwt/internal/image/JPEGFileFormat.d \
# dwt/internal/image/JPEGFixedSizeSegment.d \
# dwt/internal/image/JPEGFrameHeader.d \
# dwt/internal/image/JPEGHuffmanTable.d \
# dwt/internal/image/JPEGQuantizationTable.d \
# dwt/internal/image/JPEGRestartInterval.d \
# dwt/internal/image/JPEGScanHeader.d \
# dwt/internal/image/JPEGSegment.d \
# dwt/internal/image/JPEGStartOfImage.d \
# dwt/internal/image/JPEGVariableSizeSegment.d \
# dwt/internal/image/LEDataInputStream.d \
# dwt/internal/image/LEDataOutputStream.d \
# dwt/internal/image/LZWCodec.d \
# dwt/internal/image/LZWNode.d \
# dwt/internal/image/OS2BMPFileFormat.d \
# dwt/internal/image/PngChunk.d \
# dwt/internal/image/PngChunkReader.d \
# dwt/internal/image/PngDecodingDataStream.d \
# dwt/internal/image/PngDeflater.d \
# dwt/internal/image/PngEncoder.d \
# dwt/internal/image/PNGFileFormat.d \
# dwt/internal/image/PngFileReadState.d \
# dwt/internal/image/PngHuffmanTable.d \
# dwt/internal/image/PngHuffmanTables.d \
# dwt/internal/image/PngIdatChunk.d \
# dwt/internal/image/PngIendChunk.d \
# dwt/internal/image/PngIhdrChunk.d \
# dwt/internal/image/PngInputStream.d \
# dwt/internal/image/PngLzBlockReader.d \
# dwt/internal/image/PngPlteChunk.d \
# dwt/internal/image/PngTrnsChunk.d \
# dwt/internal/image/TIFFDirectory.d \
# dwt/internal/image/TIFFFileFormat.d \
# dwt/internal/image/TIFFModifiedHuffmanCodec.d \
# dwt/internal/image/TIFFRandomFileAccess.d \
# dwt/internal/image/WinBMPFileFormat.d \
# dwt/internal/image/WinICOFileFormat.d \
# dwt/internal/Library.d \
# dwt/internal/Lock.d \
# dwt/internal/LONG.d \
# dwt/internal/objc/bindings.d \
# dwt/internal/objc/cocoa/bindings.d \
# dwt/internal/objc/cocoa/Cocoa.d \
# dwt/internal/objc/runtime.d \
# dwt/internal/Platform.d \
# dwt/internal/SerializableCompatibility.d \
# dwt/internal/SWTEventListener.d \
# dwt/internal/SWTEventObject.d \
# dwt/internal/theme/ButtonDrawData.d \
# dwt/internal/theme/ComboDrawData.d \
# dwt/internal/theme/DrawData.d \
# dwt/internal/theme/ExpanderDrawData.d \
# dwt/internal/theme/GroupDrawData.d \
# dwt/internal/theme/ProgressBarDrawData.d \
# dwt/internal/theme/RangeDrawData.d \
# dwt/internal/theme/ScaleDrawData.d \
# dwt/internal/theme/ScrollBarDrawData.d \
# dwt/internal/theme/TabFolderDrawData.d \
# dwt/internal/theme/TabItemDrawData.d \
# dwt/internal/theme/Theme.d \
# dwt/internal/theme/ToolBarDrawData.d \
# dwt/internal/theme/ToolItemDrawData.d \
# dwt/layout/all.d \
# dwt/layout/FillData.d \
# dwt/layout/FillLayout.d \
# dwt/layout/FormAttachment.d \
# dwt/layout/FormData.d \
# dwt/layout/FormLayout.d \
# dwt/layout/GridData.d \
# dwt/layout/GridLayout.d \
# dwt/layout/RowData.d \
# dwt/layout/RowLayout.d \
# dwt/opengl/all.d \
# dwt/opengl/GLCanvas.d \
# dwt/opengl/GLData.d \
# dwt/printing/all.d \
# dwt/printing/PrintDialog.d \
# dwt/printing/Printer.d \
# dwt/printing/PrinterData.d \
# dwt/program/all.d \
# dwt/program/Program.d \
# dwt/std.d \
# dwt/widgets/all.d \
# dwt/widgets/Button.d \
# dwt/widgets/Canvas.d \
# dwt/widgets/Caret.d \
# dwt/widgets/ColorDialog.d \
# dwt/widgets/Combo.d \
# dwt/widgets/Composite.d \
# dwt/widgets/Control.d \
# dwt/widgets/CoolBar.d \
# dwt/widgets/CoolItem.d \
# dwt/widgets/DateTime.d \
# dwt/widgets/Decorations.d \
# dwt/widgets/Dialog.d \
# dwt/widgets/DirectoryDialog.d \
# dwt/widgets/Display.d \
# dwt/widgets/Event.d \
# dwt/widgets/EventTable.d \
# dwt/widgets/ExpandBar.d \
# dwt/widgets/ExpandItem.d \
# dwt/widgets/FileDialog.d \
# dwt/widgets/FontDialog.d \
# dwt/widgets/Group.d \
# dwt/widgets/IME.d \
# dwt/widgets/Item.d \
# dwt/widgets/Label.d \
# dwt/widgets/Layout.d \
# dwt/widgets/Link.d \
# dwt/widgets/List.d \
# dwt/widgets/Listener.d \
# dwt/widgets/Menu.d \
# dwt/widgets/MenuItem.d \
# dwt/widgets/MessageBox.d \
# dwt/widgets/Monitor.d \
# dwt/widgets/ProgressBar.d \
# dwt/widgets/RunnableLock.d \
# dwt/widgets/Sash.d \
# dwt/widgets/Scale.d \
# dwt/widgets/Scrollable.d \
# dwt/widgets/ScrollBar.d \
# dwt/widgets/Shell.d \
# dwt/widgets/Slider.d \
# dwt/widgets/Spinner.d \
# dwt/widgets/Synchronizer.d \
# dwt/widgets/TabFolder.d \
# dwt/widgets/TabItem.d \
# dwt/widgets/Table.d \
# dwt/widgets/TableColumn.d \
# dwt/widgets/TableItem.d \
# dwt/widgets/Text.d \
# dwt/widgets/ToolBar.d \
# dwt/widgets/ToolItem.d \
# dwt/widgets/ToolTip.d \
# dwt/widgets/Tracker.d \
# dwt/widgets/Tray.d \
# dwt/widgets/TrayItem.d \
# dwt/widgets/Tree.d \
# dwt/widgets/TreeColumn.d \
# dwt/widgets/TreeItem.d \
# dwt/widgets/TypedListener.d \
# dwt/widgets/Widget.d