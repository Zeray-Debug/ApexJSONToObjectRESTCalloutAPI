public class JSONCandidateParserUtil {
    @future //is a promise needed? Should the callout be true?
    
    public static void parseCandidateJSONResponse() {
        //Create the HTTP Class that will send the request
        HTTP http = new HTTP();

        //BUild the Request 
        HttpRequest canRequest = new HttpRequest();

        //Set the endpoint URL 
        String endpoint = ''; //Need to fill this in with the url
        String candidateID = '';
        canRequest.setEndpoint(endpoint + candidateID);

        //Set the HTTP verb to 'GET'
        canRequest.setMethod('GET');

        //Send the HTTP request and get the response in JSON Format
        HttpResponse response = http.send(canRequest);

        //check to see if the response is in the right format
        System.debug(response.getBody());

        //Next need to parse the entire JSON Response and Deseriealize it into Objects 
        JSONParser parser = JSON.createParser(response.getBody());

        while (parser.nextToken() != null) {
            //start the array of questions, TODO: need to create a custom object in the org 
            //Using the JSONToken Enum START_ARRAY to indidcate the start of an array value. This token is returned when '[' is encountered.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {

                    //Advances to the start object marker to find the first question object through the START_OBJECT Token ENum
                    //This Token value indicates the start of an object value. This token is returned when '{' is encountered.
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        
                        //need to read the entire question object, including it's array of fields will use general Object notation 
                        Question que = (Question)parser.readValueAs(Question.class);
                        //see the values returned 
                        System.debug('The Question ID is: ' + que.recordID);
                        System.debug('The Question Name is: ' + que.name);
                        System.debug('The Candidate Name is: ' + que.candidate_name);
                        System.debug('The Question Name is: ' + que.name);
                        System.debug('The Question prompt is: ' + que.prompt);
                        System.debug('The Question response is: ' + que.q_response);

                        //Next ignore the rest of the child tokens of type JSONToken.START_ARRAY and JSONToken.START_OBJECT that the parser currently points to.
                        parser.skipChildren();
                    }
                }
            }
        }

    }


    //create the inner classes used for serialization by readValueAs(). Might best to just put these in seperate classes
    public class Question  {
        public string name;
        public long recordID; 
        public string candidate_name;
        public string prompt;
        public string q_response;
        List<sObject> candidates; // what can we use this sObject list for??

        //next generate the constructor 
        public Question (string n, long id, string cName, string p, string qResp, List<SObject> canList) {
            name = n;
            recordID = id;
            candidate_name = cName;
            prompt = p;
            q_response = qResp;
            candidates = canList.deepClone();
        }
    }

    public class candidate {
        public string name;
        public long id;
        
    }
}