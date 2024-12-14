import React from 'react'
import "./ShowResponse.css"
import "./AddOrDeleteQues.css"
import {useState, useEffect} from "react";
import {FaPlus} from 'react-icons/fa'
import {useNavigate} from "react-router-dom";
import IconButton from '@mui/material/IconButton';
import SendIcon from '@mui/icons-material/Send';

const AddOrDeleteQues = (props) => {

    const navigate = useNavigate();

    const [questions, setQuestions] = useState([])
    const [deleteReasoningModal, setDeleteReasoningModal] = useState(false)
    const [deleteReasoning, setDeleteReasoning] = useState("")
    const [testName, setTestName] = useState("")
    const [quesID, setQuesID] = useState(0)

    useEffect(() => {
        const getQuestions = async (testID) => {
            const questionsFromServer = await fetchQuestions(testID)
            setQuestions(questionsFromServer.questions)
            setTestName(questionsFromServer.name)
        }

        getQuestions(props.testID).then()
    }, [])

    const fetchQuestions = async (testID) => {
        const res = await fetch('/test/' + testID + '/get_all_questions', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        })
        const data = await res.json()
        console.log(data)
        return data
    }


    const deleteClicked = (quesId) => {
        setQuesID(quesId)
        console.log("delete clicked", quesId)
        setDeleteReasoningModal(true)
    }

    const reasoningGiven = (e) => {
        e.preventDefault()
        // console.log("reasoning Given")
        // console.log(deleteReasoning)
        if (!deleteReasoning) {
            alert("Reason Can't be empty !!!")
            return
        }
        console.log(deleteReasoning)
        const deleteQuestion = async (quesId, reasoning) => {
            const res = await fetch('/test/' + props.testID + '/delete_question/' + quesId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-access-token': localStorage.getItem('token')
                },
                body: JSON.stringify({
                    quesId: quesId,
                    reasoning: reasoning
                })
            }).then(res => res.json())
            const data = res
            console.log(data)
            if (data.success) {
                alert("Question Delete Request Posted Successfully")
                setDeleteReasoningModal(false)
                const questionsFromServer = await fetchQuestions(props.testID)
                setQuestions(questionsFromServer.questions)
                setTestName(questionsFromServer.name)
            }
        }

        deleteQuestion(quesID, deleteReasoning).then()
        setDeleteReasoning("")
        setDeleteReasoningModal(false)
        alert('Your request has been posted successfully')
    }


    return (
        <>

            <div className='container'>
                <h2>
                    Request to Update Questionnaire of {testName}
                </h2>
                <hr className='line-psy'></hr>

                <div className='section'><b>Test Questions</b></div>
                <hr className='line-psy' style={{width: "30%"}}></hr>

                {
                    questions.map(
                        (question, idx) => (
                            <div className='answersHandler'>

                                <div className='questionTextContainer'>
                                    <div className='questionId'>{idx + 1}.</div>
                                    <div className='questionText'>{question.questionText}</div>
                                    <div className='ques-dlt-btn' onClick={() => deleteClicked(question.id)}>Delete
                                    </div>
                                </div>

                                {
                                    question.options.map(
                                        (option) => (
                                            <div className='optionContainer'>
                                                <label className="ckbox-container-show">{option.value}
                                                    <input type="checkbox" disabled/>
                                                    <span className="ckbox-checkmark-show"></span>
                                                </label>
                                            </div>
                                        )
                                    )
                                }
                            </div>
                        )
                    )
                }

                <div className='add-new' onClick={() => navigate('/a_ques/' + props.testID)}>
                    Add New Question
                </div>
            </div>

            {
                deleteReasoningModal && (
                    <div className='modal-dlt'>
                        <div onClick={() => {
                            setDeleteReasoningModal(false);
                            setDeleteReasoning("");
                        }} className="overlay-dlt"></div>
                        <div className='modal-content-dlt'>
                            <div className='detailContainer-dlt'>
                                <div className='header-dlt'>Enter Reasoning</div>
                                <hr className='line-psy' style={{width: "40%"}}></hr>
                            </div>

                            <div className='input-dlt'>
                                <form >
                                    <input type="text" placeholder='Enter Reasoning' value={deleteReasoning} style={{width: "70%", marginLeft: "4%", borderRadius: "10px", marginRight: "10%"}}
                                           onChange={(e) => setDeleteReasoning(e.target.value)}/>

                                    <IconButton aria-label="delete" onClick={reasoningGiven}>
                                        <SendIcon sx={{color:"#eb7575"}} />
                                    </IconButton>
                                </form>
                            </div>
                        </div>
                    </div>
                )
            }


        </>
    )
}

export default AddOrDeleteQues