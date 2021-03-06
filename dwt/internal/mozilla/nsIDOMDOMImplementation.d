module dwt.internal.mozilla.nsIDOMDOMImplementation;

import dwt.internal.mozilla.Common;
import dwt.internal.mozilla.nsID;
import dwt.internal.mozilla.nsISupports;

import dwt.internal.mozilla.nsIDOMDocumentType;
import dwt.internal.mozilla.nsIDOMDocument;
import dwt.internal.mozilla.nsStringAPI;

const char[] NS_IDOMDOMIMPLEMENTATION_IID_STR = "a6cf9074-15b3-11d2-932e-00805f8add32";

const nsIID NS_IDOMDOMIMPLEMENTATION_IID=
  {0xa6cf9074, 0x15b3, 0x11d2,
    [ 0x93, 0x2e, 0x00, 0x80, 0x5f, 0x8a, 0xdd, 0x32 ]};

interface nsIDOMDOMImplementation : nsISupports {

  static const char[] IID_STR = NS_IDOMDOMIMPLEMENTATION_IID_STR;
  static const nsIID IID = NS_IDOMDOMIMPLEMENTATION_IID;

extern(System):
  nsresult HasFeature(nsAString * feature, nsAString * version_, PRBool *_retval);
  nsresult CreateDocumentType(nsAString * qualifiedName, nsAString * publicId, nsAString * systemId, nsIDOMDocumentType *_retval);
  nsresult CreateDocument(nsAString * namespaceURI, nsAString * qualifiedName, nsIDOMDocumentType doctype, nsIDOMDocument *_retval);

}

