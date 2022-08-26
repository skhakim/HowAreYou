export function setToken(_token) {
    localStorage.setItem('token', _token);
}

export function getToken() {
    return localStorage.getItem('token');
}

export function setPersonId(_personId) {
    localStorage.setItem('personId', _personId);
}

export function getPersonId() {
    return localStorage.getItem('personId');
}

export function setIdType(_idName) {
    localStorage.setItem('idType', _idName);
}

export function getIdType() {
    return localStorage.getItem('idType');
}

export function setUsername(_name) {
    localStorage.setItem('userName', _name);
}

export function getUsername() {
    return localStorage.getItem('userName');
}

export function setIsReviewer(_isReviewer) {
    localStorage.setItem('isReviewer', _isReviewer);
}

export function getIsReviewer() {
    return localStorage.getItem('isReviewer');
}

export function clearAll() {
    localStorage.setItem('token', '');
    localStorage.setItem('personId', '');
    localStorage.setItem('idType', '');
    localStorage.setItem('userName', '');
    localStorage.setItem('isReviewer', '');
}

export function questionnaire_post_response(test_id, options)
{
    const option_ids = Object.values(options);
    console.log('QQOptions', options)
    console.log('QQOption Ids', option_ids)
    var option_text = '';
    for (let option_id in option_ids) {
        option_text += "{\n" +
            "                        \"id\": \"" + option_ids[option_id]  + "\",\n" +
            "                        \"type\": \"options\"\n" +
            "                    },";
    }
    //console.log(option_text.substring(0, option_text.length - 1))
    //if(idType === 'patient_id')
        return "{\n" +
        "      \"data\": {\n" +
        "        \"type\": \"tr\",\n" +
        "        \"attributes\": {\n" +
        "          \"test_id\": " + test_id +",\n" +
        "          \"patient_id\": " + getPersonId() + ",\n" +
        "          \"submitted_at\": \"" + new Date().toLocaleString('en-GB') + "\"\n" +
        "        },\n" +
        "        \"relationships\": {\n" +
        "            \"options\": {\n" +
        "                \"data\": [" + option_text.substring(0, option_text.length - 1) +
        "                ]\n}\n" +
        "            }\n" +
        "        }\n" +
        "    }";
    return '';
}
