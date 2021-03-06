module dwt.internal.mozilla.nsICollection;

import dwt.internal.mozilla.Common;
import dwt.internal.mozilla.nsID;
import dwt.internal.mozilla.nsISupports;

import dwt.internal.mozilla.nsISerializable;
import dwt.internal.mozilla.nsIEnumerator;

const char[] NS_ICOLLECTION_IID_STR = "83b6019c-cbc4-11d2-8cca-0060b0fc14a3";

const nsIID NS_ICOLLECTION_IID=
  {0x83b6019c, 0xcbc4, 0x11d2,
    [ 0x8c, 0xca, 0x00, 0x60, 0xb0, 0xfc, 0x14, 0xa3 ]};

interface nsICollection : nsISerializable {

  static const char[] IID_STR = NS_ICOLLECTION_IID_STR;
  static const nsIID IID = NS_ICOLLECTION_IID;

extern(System):
  nsresult Count(PRUint32 *_retval);
  nsresult GetElementAt(PRUint32 index, nsISupports *_retval);
  nsresult QueryElementAt(PRUint32 index, nsIID * uuid, void * *result);
  nsresult SetElementAt(PRUint32 index, nsISupports item);
  nsresult AppendElement(nsISupports item);
  nsresult RemoveElement(nsISupports item);
  nsresult Enumerate(nsIEnumerator *_retval);
  nsresult Clear();

}

