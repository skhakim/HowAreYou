import React from 'react'
import "./FileRequest.css";
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";

export function CreateFileRequest() {

    const [title, setTitle] = React.useState("");
    const [desc, setDesc] = React.useState("");
    const navigate = useNavigate();

    const submit = async (title, desc) => {
        console.log("Just in submit", title, desc);
        const res = await fetch('http://localhost:5000/cfr',
            {
                method: "POST",
                headers: {
                    'Content-type': 'application/vnd.api+json'
                    , 'Accept': 'application/vnd.api+json'
                    , 'x-access-token': getToken()
                },
                body: JSON.stringify({
                    'title' : title, 'desc' : desc
                })
            }
        );
        return res;
    }

    return (
        <div style={{marginTop:"5%"}} className="reqForm">
            <form >
                <div className="form-group">
                    <label style={{fontSize:"1.1rem"}} htmlFor="exampleInputEmail1"><b>Request Title</b></label>
                    <input type="text"  id="exampleInputEmail1" aria-describedby="emailHelp" style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", }}
                           placeholder="Enter Title" onChange={(e) => setTitle(e.target.value)}/>
                </div>
                <br/><br/>
                <div className="form-group">
                    <label style={{fontSize:"1.1rem", marginBottom:"2%"}} htmlFor="exampleInputPassword1"><b>Request Description</b></label>
                    <textarea rows={5} cols={100} id="exampleInputPassword1" placeholder="Please detail out what you need" style={{resize:"none", width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "80px", outline: "none", marginTop:"25px" }}
                     onChange={(e) => setDesc(e.target.value)}/>
                </div>
                <br/> <br/>
                <div className="done-btn" onClick={(e) => {e.preventDefault(); submit(title, desc).then(
                        (response) => {
                            if(response.ok) {
                                alert("Thanks for uploading the file request. It will be checked by review board members.");
                                navigate('/psyhome');
                            } else {
                                alert("Please try again");
                            }
                        }
                        );}}>
                    Submit
                </div>
            </form>
        </div>
    );
}
