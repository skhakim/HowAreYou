import React from 'react'
import "./AddQuestion.css"
import "./ShowResponse.css"
import {useState, useEffect} from "react";
import {FaPlus, FaTimes} from 'react-icons/fa'
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';
import IconButton from '@mui/material/IconButton';

const AddQuestion = (props) => {

    const [quesBody, setQuesBody] = useState("")
    const [options, setOptions] = useState([])
    const [addOptionWidget, setAddOptionWidget] = useState(false)
    const [newOptionText, setNewOptionText] = useState("")
    const [newOptionScore, setNewOptionScore] = useState("")


    const newOptionAdded = () => {

        if(!newOptionText){
            alert("Option Field Empty")
            return
        }

        if(!newOptionScore) {
            alert("Option Score Empty")
            return;
        }

        console.log(newOptionText)
        var index = 0;
        while( index < options.length){
            if(options[index]["text"] === newOptionText){
                alert("Option Already Exists. Try New one")
                index++
                return
            }
            index++;
        }
        options.push({
            "text": newOptionText, "score": newOptionScore
        })
        setAddOptionWidget(false)
        setNewOptionText("")
        setNewOptionScore("")
    }

    const removeOption = (option) => {
        console.log(option)
        var filtered = options.filter(opt => opt !== option)
        setOptions(filtered)
    }

    const submit = () => {
        if(!quesBody){
            alert("Question Body is empty !!!")
            return
        }

        if(options.length < 1){
            alert("No Options Given")
            return
        }

        var response = {}
        response["text"] = quesBody
        response["options"] = options
        console.log(response)

        //send response to backend
        const addQuestion = async (testID, response) => {
            const res = await fetch('/test/' + testID + '/add_question', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-access-token': localStorage.getItem('token')
                },
                body: JSON.stringify(response)
            })
            const data = await res.json()
            console.log(data)
            return data
        }

        addQuestion(props.testID, response).then(response => {
            if(response.success){
                alert("Question Added Successfully")

            }
        })
        
        setQuesBody("")
        setOptions([])


    }

    return (
        <div className='container'>
            <div style={{fontSize:"1.2rem", fontWeight:"400"}}>
                <b>Request to Update Questionnaire of PTSD Test - Change This</b>
            </div>
            <hr className='line-psy'></hr>

            <div className='section'><b>Add New Questions</b></div>
            <hr className='line-psy' style={{width:"30%"}}></hr>

            <div className='ques-body'>
                <label style={{fontSize:"1.1rem"}}><b>Question Body</b></label> <br/><br/>
                <textarea style={{"resize":"None", marginLeft:"3%"}} rows="3" cols="70" placehodler="Enter Question Body" value={quesBody} onChange={(e) => {setQuesBody(e.target.value)}} />
                <br/><br/><br/>
            </div>


            <div className='options'>
                <div className='option-header'>
                    <div style={{fontSize:"1.1rem"}}><b>Options</b></div> 

                    {
                        !addOptionWidget && (
                            <div onClick={() => {setAddOptionWidget(true); }} className='add-new-option'>
                                <AddIcon sx={{mt:"2px"}} /> <div style={{marginLeft:"4px"}}>Add New Option</div>
                            </div>
                        )
                    }
                    

                </div>
                

                <div>
                    <ul style={{"marginTop":"2%"}}>
                        {
                            options.map(
                                (option) => (

                                    <>
                                        <div style={{marginLeft:"10px", display:"flex"}} className='optionContainer'>
                                            <label style={{marginRight:"50px"}} className="ckbox-container-show">{option.text}
                                                <input type="checkbox" value={option.text} disabled/>
                                                <span className="ckbox-checkmark-show"></span>
                                            </label>

                                            <IconButton onClick={() => removeOption(option)} sx={{mt:"-10px", '&:hover':{backgroundColor: '#a39d9d',}}}> <DeleteIcon sx={{ color:"#f03224"}} /> </IconButton>
                                        </div>                                   
                                    </>                                    
                                )
                            )
                        }
                    </ul>
                </div>
                
            </div>

            {
                addOptionWidget && (
                    <div>
                        <label style={{marginLeft:"25px"}}><b>Add New Option</b></label>
                        
                        <div style={{display:"flex", marginLeft:"60px", height:"80px"}}>
                            <input style={{"marginLeft":"0%", "width":"20%", borderRadius:"4px"}} type="text" placeholder="Enter Option" value={newOptionText} onChange={(e) => setNewOptionText(e.target.value)} />
                            <br/>
                            <input style={{"marginLeft":"2%", "width":"20%"}} type="text" placeholder="Enter Score" value={newOptionScore} onChange={(e) => setNewOptionScore(e.target.value)} />

                            
                            <div style={{marginTop:"28px", marginLeft:"4%"}} className='save' onClick={() => newOptionAdded()}>
                                Save
                            </div>

                            <div style={{marginTop:"28px", marginLeft:"2%"}} className='cancel' onClick={() => {setAddOptionWidget(false); setNewOptionText(""); setNewOptionScore("")}}>
                                Cancel
                            </div>
                            
                        </div>
                        
                    </div>
                )
            }

            <div className='done-btn' onClick={() => submit()}>
                Send Request
            </div>
        </div>
    )
}

export default AddQuestion