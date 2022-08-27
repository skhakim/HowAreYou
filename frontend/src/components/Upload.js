import React, {useRef} from 'react';
import axios from 'axios';
import useFileUpload from 'react-use-file-upload';
import {getToken} from "./Variables";
import FileUploadIcon from '@mui/icons-material/FileUpload';
import DeleteIcon from '@mui/icons-material/Delete';
import IconButton from '@mui/material/IconButton';
import Button from '@mui/material/Button';
import ClearAllIcon from '@mui/icons-material/ClearAll';

export const Upload = (props) => {
    const {
        files,
        fileNames,
        fileTypes,
        totalSize,
        totalSizeInBytes,
        handleDragDropEvent,
        clearAllFiles,
        createFormData,
        setFiles,
        removeFile,
    } = useFileUpload();

    const inputRef = useRef();

    const handleSubmit = async (e) => {
        e.preventDefault();

        const formData = createFormData();
        console.log(formData);

        for (var pair of formData.entries()) {
            console.log(pair[0] + ', ' + pair[1]);
        }

        try {
            await axios.post('/upload/' + props.frID, formData, {headers:{
                'content-type': 'multipart/form-data',
                'x-access-token': getToken()
            }});
        } catch (error) {
            console.error('Failed to submit files.');
        }
    };

    return (
        <div>
            <h3>Upload Files</h3>

            {/* <div style={{marginLeft:"50px"}}>Please upload any file(s) of your choosing.</div> */}

            <div className="form-container">
                {/* Display the files to be uploaded */}
                <div>
                    {
                        fileNames.map(
                            (name) => (
                                <div style={{marginLeft:"50px", display:"flex"}} className='optionContainer'>
                                    <label style={{marginRight:"50px"}} className="ckbox-container-show">{name}
                                        <input type="checkbox" value={name} disabled/>
                                        <span className="ckbox-checkmark-show"></span>
                                    </label>

                                    <IconButton onClick={() => removeFile(name)} sx={{mt:"-10px", '&:hover':{backgroundColor: '#a39d9d',}}}> <DeleteIcon sx={{ color:"#f03224"}} /> </IconButton>
                                </div>                                   
                            )
                        )
                    }
                    {/* <ul>
                        {fileNames.map((name) => (
                            <li key={name}>
                                <span>{name}</span>

                                <span onClick={() => removeFile(name)}><i className="fa fa-times"/></span>
                            </li>
                        ))}
                    </ul> */}

                    {/* {files.length > 0 && (
                        <ul>
                            <li>File types found: {fileTypes.join(', ')}</li>
                            <li>Total Size: {totalSize}</li>
                            <li>Total Bytes: {totalSizeInBytes}</li>

                            <li className="clear-all">
                                <button onClick={() => clearAllFiles()}>Clear All</button>
                            </li>
                        </ul>
                    )} */}

                    {
                        files.length > 0 && ( 
                            <div style={{display:"flex"}}>
                                <Button sx={{mt:2, ml:8, bgcolor:"#e33232", "&:hover":{bgcolor:"#e01212"} }} variant="contained">
                                    Remove Files
                                </Button>

                                <Button onClick={handleSubmit} sx={{mt:2, ml:8, bgcolor:"#437838", "&:hover":{bgcolor:"#1c7a09"} }} variant="contained">
                                    Submit Files
                                </Button>
                            </div>
                            
                        )
                    }
                </div>
            </div>

                {/* Provide a drop zone and an alternative button inside it to upload files. */}
            {/* <div
                onDragEnter={handleDragDropEvent}
                onDragOver={handleDragDropEvent}
                onDrop={(e) => {
                    handleDragDropEvent(e);
                    setFiles(e, 'a');
                }}
                style={{border:"2px solid red"}}
            > */}

                <div onDragEnter={handleDragDropEvent} onDragOver={handleDragDropEvent}  onDrop={(e) => {handleDragDropEvent(e);setFiles(e,'a');}} onClick={() => inputRef.current.click()} className='uploadHere'><FileUploadIcon sx={{fontSize:"6rem", mt:"15px", ml:"80px", color:"#1b5153", "&:hover":{color:"#044446", fontSize:"6.2rem", ml:"78px", mt:"5px"} }} /></div>
                <div style={{fontSize:"1.1rem", marginLeft:"37%", marginTop:"10px"}}>Select or Drag File(s) to Upload Here.</div>
                {/* <button onClick={() => inputRef.current.click()}>Or select files to upload</button> */}

                {/* Hide the crappy looking default HTML input */}
                <input
                    ref={inputRef}
                    type="file"
                    multiple
                    style={{display: 'none'}}
                    onChange={(e) => {
                        setFiles(e, 'a');
                        inputRef.current.value = null;
                    }}
                />
            {/* </div> */}
            

            {/* <div style={{marginLeft:"43%"}} className="done-btn" onClick={handleSubmit}>
                Submit
            </div> */}
        </div>
    );
};