import React, {useEffect, useState} from 'react';
import ReactDOM from 'react-dom';

const callRestApi = async (restEndpoint) => {
    const response = await fetch(restEndpoint, {method: "GET", headers: {'Accept': 'application/vnd.api+json'}});
    console.log(response)
    const jsonResponse = await response.json();
    // console.log(jsonResponse.data.relationships.questions.data);
    return jsonResponse;
};

export function OptionText(props) {

    const restEndPoint = '/api/options/' + props.optionId;

    const [apiResponse, setApiResponse] = useState({
        option_text: "not loaded yet",
        option_id: 0
    });

     useEffect(() => {
        callRestApi(restEndPoint).then(
            result => setApiResponse({
                option_text: result.data.attributes.option_text,
                option_id: result.data.attributes.option_id
            }));
    }, []);

     return (
        <div>
            <p>{apiResponse.option_text}</p>
        </div>
    );
}

export function ListOptionsOfAQuestion(props) {

    const restEndPoint = '/api/questions/' + props.questionId;

    const [apiResponse, setApiResponse] = useState({
        question_text: "not loaded yet",
        question_id: 0,
        options: []
    });

     useEffect(() => {
        callRestApi(restEndPoint).then(
            result => setApiResponse({
                question_text: result.data.attributes.question_text,
                question_id: result.data.attributes.question_id,
                options: result.data.relationships.options.data.sort((a, b) => a.id - b.id)
            }));
    }, []);

     return (
        <div>
            <h3>{props.idx} {apiResponse.question_text}</h3>
            {apiResponse.options.map((option, idx) => <OptionText optionId={option.id}/>)}
            <br/>
        </div>
    );
}

export function ListQuestionsOfATest(props) {

    const restEndPoint = '/api/tests/' + props.testId;

    const [apiResponse, setApiResponse] = useState({
        test_name: "not loaded yet",
        test_description: "not loaded yet",
        test_id: 0,
        questions: []
    });

    useEffect(() => {
        callRestApi(restEndPoint).then(
            result => setApiResponse({
                test_name: result.data.attributes.name,
                test_description: result.data.attributes.description,
                test_id: result.data.test_id,
                questions: result.data.relationships.questions.data.sort((a, b) => a.id - b.id)
            }));
    }, []);

    return (
        <div>
            <h1>React App</h1>
            <p>Test Name: {apiResponse.test_name}</p>
            <p>Test Description: {apiResponse.test_description}</p>
            {apiResponse.questions.map((question, idx) => <ListOptionsOfAQuestion questionId={question.id} key={idx}/>)}
        </div>
    );
};