%dw 2.0
output application/json
---
errsfmessage: if(
    ((error.muleMessage.payload.errorDescription !=null) and sizeOf(error.muleMessage.payload.errorDescription[0]) >1 
    )) if(error.muleMessage.payload.errorDescription[0].message !=null) error.muleMessage.payload.errorDescription[0].message else 'Blank error payload' else error.muleMessage.payload.errorDescription