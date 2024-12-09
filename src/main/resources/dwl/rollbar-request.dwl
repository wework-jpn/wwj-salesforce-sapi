%dw 2.0
output application/json
import * from dw::core::Strings
var errorIdentifier = ((error.errorType.namespace default "") ++ ":" ++ (error.errorType.identifier default ""))
var errodescr=if ( error.description == null ) vars.errorMessage as String else error.description as String
var exce =errodescr remove "'"
var url =substringBefore(substringAfter(errodescr,"'"),"'")
var test=substringBefore(exce,"https")
var https = substringAfter(substringAfter(exce, "//"),"/")
var httpmessage=test ++ https
var mel =substringBefore(errodescr,":")
var melexce =mel remove "\""
---
{
     access_token: p("secure::rollbar.accesstoken"),
    "data": {
    environment: if ( p("rollbar.environment") != null ) p("rollbar.environment") else p("rollbar.environment"),
    "code_version": p("api.version"),
    "notifier": {
      "name": p("api.name"),
        "version": p("api.version")
    },
    "context": if((error.errorType.asString contains("HTTP")) or (errodescr contains("HTTP")) or  (errodescr contains("HTTPS")) or  (errodescr contains("http")) or  (errodescr contains("https")))"HTTP:ERROR" else error.errorType.asString,
    "level": "error",
    "language": "mulesoft",
   
   "custom": {
     
        "error_detail": if((error.muleMessage.payload != null) and (typeOf(error.muleMessage.payload) as String == "Object") and (error.muleMessage.payload.errorDescription != null))
                        if(typeOf(error.muleMessage.payload.errorDescription) as String == "String") 
                        	(error.description default "") ++ " - " ++ (error.muleMessage.payload.errorDescription default "") 
                        else (error.muleMessage.payload.errorDescription default "")
                      else if(error.muleMessage.payload != null)
                        error.muleMessage.payload
                      else if (error.detailedDescription != null) 
                        error.detailedDescription
                      else if(vars.retryErrorDescription != null)
                        vars.retryErrorDescription
                      else "",
        "api_url": if(error.errorType.asString contains("HTTP"))url else if ((error.errorType.asString contains("HTTP")) or (errodescr contains("HTTP")) or  (errodescr contains("HTTPS")) or  (errodescr contains("http")) or  (errodescr contains("https")))url else if(error.errorType.asString contains("MULE:EXPRESSION"))"MULE EXPRESSION ERROR" else error.errorType.asString ,
        "api_error_type": vars.errorCodes default errorIdentifier,
		"uniqueidentifier_id": correlationId
    },
        "mulesoft" : {
            "error" : if ( error.detailedDescription == null ) vars.errorMessage as String else if(vars.apierror !=null) vars.apierror else error.detailedDescription as String
        },
    "body": {
        "message": 
        {
            body: if((error.errorType.asString contains("HTTP")) or (errodescr contains("HTTP")) or  (errodescr contains("HTTPS")) or  (errodescr contains("http")) or  (errodescr contains("https")))httpmessage else if(error.errorType.asString contains("MULE:EXPRESSION"))"MULE:EXPRESSION_ERROR" else if(error.errorType.asString contains("SALESFORCE:INVALID_INPUT")) "SALESFORCE:INVALID_INPUT" else errodescr,
            route:error.failingComponent,
            timestamp: now()
        }
            
            
        }
}}