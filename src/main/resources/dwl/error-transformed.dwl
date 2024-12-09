%dw 2.0
import modules::JSONLoggerModule
output application/json
---
{
	Message: "Error occurred",
	ErrorCode: if ( !isEmpty(vars.errorCodes) ) vars.errorCodes else "500",
	ErrorDateTime: now(),
	ErrorDescription: if ( !isEmpty(vars.error.errsfmessage) ) vars.error.errsfmessage
                      else if ( error.description != null ) error.description
   					  else if ( (error.muleMessage.payload != null) and (typeOf(error.muleMessage.payload) as String == "Object") and 
   					  			(error.muleMessage.payload.errorDescription != null)) (error.detailedDescription default "") ++ " - " ++ (error.muleMessage.payload.errorDescription default "")
					  else if ( (error.muleMessage.payload != null) and (typeOf(error.muleMessage.payload) as String != "Object") ) JSONLoggerModule::stringifyNonJSON(error.muleMessage.payload)
					  else if ( error.detailedDescription != null ) error.detailedDescription
    				  else if ( vars.retryErrorDescription != null ) vars.retryErrorDescription
    				  else ""
}