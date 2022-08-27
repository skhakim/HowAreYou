import React, { useState } from 'react';
import styles from "./newCss/Signup.module.css"
import {useNavigate} from "react-router-dom";
import PersonIcon from '@mui/icons-material/Person';
import Avatar from '@mui/material/Avatar';
import {getToken, setToken, setIdType, setPersonId, setUsername, getIdType} from './Variables.js';

const SignupModalNew = ({signUpModalOff, loginModalOn}) => {

    const navigate = useNavigate();

    const [isPatient, setIsPatient] = useState(true)

    const [personType, setPersonType] = useState("patient")
    const [gender, setGender] = useState("female")
    const [name, setName] = useState("")
    const [email_, setEmail_] = useState("")
    const [password_, setPassword_] = useState("")
    const [dob, setDob] = useState("")
    const [height, setHeight] = useState("")
    const [weight, setWeight] = useState("")
    const [location, setLocation] = useState("")
    const [certificateId, setCertificateId] = useState("")




    const promptSignup = async (signupInfo) => {
        console.log('signupInfo', signupInfo)
        const res = await fetch(isPatient ? '/signup/1' : '/signup/2',
            {
                method: "POST",
                headers: {'Content-type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json'},
                body: JSON.stringify(signupInfo)
            }
        )
        const data = await res.json()
        console.log(data)

        if(data['response'] == 'success') {
            if(isPatient)
                alert('Signup Successful')
            else
                alert('Your signup request will be checked by a review board member. Please keep waiting.')
        } else if(data['response'] == 'failure') {
            alert('Signup Unsuccessful')
        }
    }

    const onSignUpSubmit = (e) => {
        e.preventDefault()

        if(!name){
            alert("Name should not be empty !!!")
            return
        }

        if(!email_){
            alert("Email should not be empty !!!")
            return
        }

        if(!password_){
            alert("Password should not be empty !!!")
            return
        }

        if(!dob){
            alert("Date of Birth should not be empty !!!")
            return
        }

        if(isPatient){
            if(!height){
                alert("Height should not be empty !!!")
                return
            }

            if(!weight){
                alert("Weight should not be empty !!!")
                return
            }

            if(!location){
                alert("Location should not be empty !!!")
                return
            }
        }
        else{
            if(!certificateId){
                alert("Certificate No. should not be empty !!!")
                return
            }
        }

        

        promptSignup({personType, name, email_, password_, dob, gender, height, weight, location, certificateId})

        setPersonType("patient")
        setIsPatient(true)
        setName("")
        setEmail_("")
        setPassword_("")
        setDob("")
        setGender("female")
        setHeight("")
        setWeight("")
        setLocation("")
        setCertificateId("")

        signUpModalOff();

    }

    const changePersonType = (e) => {
        setPersonType(e.target.value)
        setIsPatient(!isPatient)
    }

    return (
        <div className={styles.loginModal}>
            <div onClick={signUpModalOff} className={styles.loginOverlay}></div>

            <div className={styles.loginModalContent}>

                <Avatar className={styles.loginAvatar} sx={{ bgcolor:"#60c4bc", width:"100px", height:"100px" }}>
                    <PersonIcon sx={{width:"90px", height:"90px"}} />
                </Avatar>

                <div className={styles.loginTitle}>
                    Member Signup
                </div>


                <div className={styles.formDiv}>
                    <form onSubmit={onSignUpSubmit}>

                        <div className={styles.row2}>
                            <select value={personType} onChange={(e) => changePersonType(e)} style={{width: "93%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}>
                                <option value="patient">Patient</option>
                                <option value="psychiatrist">Psychiatrist</option>
                            </select>
                        </div>

                        <div className={styles.row}>
                            <input type="text" placeholder="Full Name" value={name} onChange={(e) => setName(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }} />
                        </div>

                        <div className={styles.row}>
                            <input type="text" className={styles.inp} id="email" name="email" placeholder="Email" value={email_} onChange={(e) => setEmail_(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }} />
                        </div>

                        <div className={styles.row2}>
                            <input type="password" className={styles.inp} id="password" name="password" placeholder="Password" value={password_} onChange={(e) => setPassword_(e.target.value)} style={{width: "93%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}/>
                        </div>


                        <div className={styles.row2}>
                            <select value={gender} onChange={(e) => setGender(e.target.value)} style={{width: "93%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}>
                                <option value="female">Female</option>
                                <option value="male">Male</option>
                                <option value="others">Others</option>
                            </select>
                        </div>

                        <div className={styles.row}>
                            <input type="text" placeholder="DD-MM-YYYY" value={dob} onChange={(e) => setDob(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}/>
                        </div>


                        {isPatient ?
                            (
                                <>
                                    <div className={styles.row}>
                                        <input type="text" placeholder="Height - Inches" value={height} onChange={(e) => setHeight(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}/>
                                    </div>

                                    <div className={styles.row}>
                                        <input type="text" placeholder="Weight - Kgs" value={weight} onChange={(e) => setWeight(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}/>
                                    </div>

                                    <div className={styles.row}>
                                        <input type="text" placeholder="Location" value={location} onChange={(e) => setLocation(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}/>
                                    </div>
                                </>
                            ):
                            (
                                <>
                                    <div className={styles.row}>
                                        <input type="text" placeholder="Certificate No." value={certificateId} onChange={(e) => setCertificateId(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", '&focus':{border: "5px solid #60c4bc"} }}/>
                                    </div>
                                </>
                            )
                                    
                        }



                        <div className={styles.row}>
                            <input type="submit" value="Sign Up" style={{width: "90%", marginLeft: "4%", backgroundColor: "#60c4bc", color:"white", padding: "12px 20px", border: "none", borderRadius: "4px", cursor: "pointer", fontSize: "1.1rem"}}/>
                        </div>
                    </form>
                </div>

                <div className={styles.txt}>Already Have an Account?</div>
                <div className={styles.decision} onClick={() => {signUpModalOff(); loginModalOn();}}>Log In</div>
                

                <span className={styles.closeLoginModal} onClick={signUpModalOff}>
                    &times;
                </span>
            </div>
        </div>
    )
}

export default SignupModalNew