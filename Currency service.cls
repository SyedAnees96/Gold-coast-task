//Integration api key availble.

public with sharing class CurrencyService {
    public CurrencyService() {}

   @AuraEnabled(cacheable=true continuation=true)
    public static Object getCurrency(String targetCurrency,String getDate) {

		
		System.debug(targetCurrency); // Outputs: AUDCAD
        //instanting the class by specifying the timeout
        Continuation c = new Continuation(100);
        
        //callback method
        c.ContinuationMethod = 'processResponse';
            
        c.state = 'My own data';
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        System.debug('https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_fjaTkHhBn5RbYuLvdWbZTKClkmb2EurA0njkBJWZ&date='+getDate+'&currencies='+targetCurrency.replaceAll('[\\[\\],"]', ''));
        req.setEndpoint('https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_fjaTkHhBn5RbYuLvdWbZTKClkmb2EurA0njkBJWZ&date='+getDate+'&currencies='+targetCurrency.replaceAll('[\\[\\]"]', ''));
        //req.setEndpoint('https://api.freecurrencyapi.com/v1/historical?apikey=fca_live_fjaTkHhBn5RbYuLvdWbZTKClkmb2EurA0njkBJWZ&Date='+getDate);
        req.setMethod('GET');
        c.addHttpRequest(req);
        return c;
        
        //req.setHeader('apikey', 'xxxx');
        //res = http.send(req);
	//system.debug('res'+res);
       // Map<string, object> responseMap = (Map<string, object>) JSON.deserializeUntyped(res.getbody());
        //system.debug('reponseMap'+responseMap);
      //system.debug()
       // return responseMap.get('data');
    }
    
    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state){
        
        HttpResponse response = Continuation.getResponse(labels[0]);
        //String result = response.getBody();
        Map<string, object> responseMap = (Map<string, object>) JSON.deserializeUntyped(response.getbody());
        //return result;
        return responseMap.get('data');
    }
}
