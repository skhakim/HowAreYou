import React, {useEffect, useState} from 'react';
import "./Questions.css"
import ReactDOM from 'react-dom';
import {questionnaire_post_response} from "./Variables";
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";


const callRestApi = async (restEndpoint) => {
    const response = await fetch(restEndpoint, {
        method: "GET", headers: {
            'Accept': 'application/vnd.api+json'
            , 'x-access-token': getToken()
        }
    });
    // console.log(response)
    const jsonResponse = await response.json();
    // console.log(jsonResponse.data.relationships.questions.data);
    //console.log(restEndpoint + " " + jsonResponse);
    return jsonResponse;
};

const callRestApiForPost = async (restEndpoint, message_body) => {
    const response = await fetch(restEndpoint, {
        method: "POST", headers: {
            'Accept': 'application/vnd.api+json'
            , 'Content-Type': 'application/vnd.api+json'
            , 'x-access-token': getToken()
        }
        , body: message_body
    });
    console.log("Body: ", message_body)
    console.log("Response: ", response)
    const jsonResponse = await response.json();
     console.log(jsonResponse.data);
    await fetch('calculate_result/' + jsonResponse.data.attributes.test_result_id, {method: "POST"}).then()
    return jsonResponse;
};

var options = {}


export function OptionText(props) {

    const restEndPoint = '/api/options/' + props.optionId;

    const [apiResponse, setApiResponse] = useState({
        option_text: "not loaded yet",
        option_id: 0
    });

    useEffect(() => {
        callRestApi(restEndPoint).then(
            (result) => {

                setApiResponse({
                    option_text: result.data.attributes.option_text,
                    option_id: result.data.attributes.option_id
                })
            });
    }, []);

    return (
        <div className="form-check form-check">
            <input className="radio" type="radio" name={props.questionId} value={apiResponse.option_id}
                   onClick={() => {
                       options[props.questionId] = props.optionId;
                       console.log(options)
                   }}/>
            <label className="form-check-label" htmlFor="inlineRadio1">{apiResponse.option_text}</label>
        </div>

    );
}

export function ListOptionsOfAQuestion(props) {
    // console.log('props', props)

    const restEndPoint = '/api/questions/' + props.questionId;

    const [apiResponse, setApiResponse] = useState({
        question_text: "not loaded yet",
        question_id: 0,
        options: []
    });

    const [approved, setApproved] = useState(false)

    useEffect(() => {
        callRestApi(restEndPoint).then(
            result => {
                console.log("RES:", result, result.data.attributes.is_approved)
                if (result.data.attributes.is_approved) {
                    setApiResponse({
                        question_text: result.data.attributes.question_text,
                        question_id: result.data.attributes.question_id,
                        options: result.data.relationships.options.data.sort((a, b) => a.id - b.id)
                    })
                }
                setApproved(result.data.attributes.is_approved)
            });
    }, []);

    if (approved)
        return (
            <div>
                <div className='questionTextContainer'>
                    <div className='questionId'> {props.key_id}.</div>
                    <div className='questionText'>{apiResponse.question_text}</div>
                </div>
                <div className='optionContainer'>
                    {apiResponse.options.map((option, idx) => <OptionText optionId={option.id}
                                                                          questionId={apiResponse.question_id}/>)}
                </div>
                <br/>
            </div>
        )
    else return <></>;
}

export function ListQuestionsOfATest(props) {

    console.log('props', props);
    const restEndPoint = '/api/tests/' + props.testId;
    const navigate = useNavigate();


    const [apiResponse, setApiResponse] = useState({
        test_name: "not loaded yet",
        test_description: "not loaded yet",
        test_id: 0,
        questions: []
    });

    useEffect(() => {
        callRestApi(restEndPoint).then(
            result => {
                setApiResponse({
                    test_name: result.data.attributes.name,
                    test_description: result.data.attributes.description,
                    test_id: result.data.test_id,
                    questions: result.data.relationships.questions.data.sort((a, b) => a.id - b.id)
                })
                console.log("RES", result.json())
            });
    }, []);

    return (
        <div className='container'>
            <h1>Test Name: {apiResponse.test_name}</h1>
            <p>{apiResponse.test_description}</p>
            <form>
                {apiResponse.questions.map((question, idx) => <ListOptionsOfAQuestion
                    questionId={question.id} key_id={idx + 1}/>)}
            </form>

            <input type="submit" className="login-btn-modal" value="Submit" style={{width: '10%'}}
                   onClick={() => {
                       //console.log("Options: ", options);
                       const post_response = questionnaire_post_response(props.testId, options);
                       //console.log(post_response);
                       callRestApiForPost('http://localhost:5000/api/tr', post_response).then(r => {
                           console.log(r);
                           alert("Response submitted successfully!");
                       });
                       navigate('/');
                   }}/>
        </div>
    );
};
