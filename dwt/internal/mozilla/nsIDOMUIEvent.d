module dwt.internal.mozilla.nsIDOMUIEvent;

import dwt.internal.mozilla.Common;
import dwt.internal.mozilla.nsID;

import dwt.internal.mozilla.nsIDOMEvent;
import dwt.internal.mozilla.nsStringAPI;
import dwt.internal.mozilla.nsIDOMAbstractView;

const char[] NS_IDOMUIEVENT_IID_STR = "a6cf90c3-15b3-11d2-932e-00805f8add32";

const nsIID NS_IDOMUIEVENT_IID=
  {0xa6cf90c3, 0x15b3, 0x11d2,
    [ 0x93, 0x2e, 0x00, 0x80, 0x5f, 0x8a, 0xdd, 0x32 ]};

interface nsIDOMUIEvent : nsIDOMEvent {

  static const char[] IID_STR = NS_IDOMUIEVENT_IID_STR;
  static const nsIID IID = NS_IDOMUIEVENT_IID;

extern(System):
  nsresult GetView(nsIDOMAbstractView  *aView);
  nsresult GetDetail(PRInt32 *aDetail);
  nsresult InitUIEvent(nsAString * typeArg, PRBool canBubbleArg, PRBool cancelableArg, nsIDOMAbstractView viewArg, PRInt32 detailArg);

}

