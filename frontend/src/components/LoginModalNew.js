import React, { useState } from 'react';
import styles from "./newCss/Login.module.css"
import {useNavigate} from "react-router-dom";
import PersonIcon from '@mui/icons-material/Person';
import Avatar from '@mui/material/Avatar';
import {getToken, setToken, setIdType, setPersonId, setUsername, getIdType, setIsReviewer} from './Variables.js';
import Input from '@mui/material/Input';


const LoginModalNew = ({loginModalOff, signUpModalOn}) => {

    const navigate = useNavigate();

    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')


    const promptLogin = async (loginInfo) => {
        const res = await fetch('/login',
            {
                method: "POST",
                headers: {'Content-type': 'application/vnd.api+json'
                        , 'Accept': 'application/vnd.api+json'},
                body: JSON.stringify(loginInfo)
            }
        );
        try {
            const data = await res.json()
            setToken(data[0]['token'])
            setIdType(data[1]['id_name'])
            setPersonId(data[2]['person_id'])
            setUsername(data[3]['name'])
            setIsReviewer(data[4]['is_reviewer'])
            return true
        } catch (error) {
            console.log(error)
            alert('Unsuccessful Login')
            return false
        }
    }

    const onLoginSubmit = (e) => {
        e.preventDefault()

        if(!email){
            alert("Email should not be empty !!!")
            return
        }

        if(!password){
            alert("Password should not be empty !!!")
            return
        }

        promptLogin({email, password}).then((e) => {
            if(e) {
                // window.location.reload(true)
                if (getIdType() == 'patient_id') {
                    navigate('/tests', {replace: true})
                }
                else if (getIdType() == 'psychiatrist_id') {
                    navigate('/psyhome', {replace: true})
                }
                window.location.reload(true)
            }
            else
                navigate('/')
        })

        setEmail('')
        setPassword('')
        loginModalOff();

    }

    return (
        <div className={styles.loginModal}>
            <div onClick={loginModalOff} className={styles.loginOverlay}></div>

            <div className={styles.loginModalContent}>

                <Avatar className={styles.loginAvatar} sx={{ bgcolor:"#60c4bc", width:"100px", height:"100px" }}>
                    <PersonIcon sx={{width:"90px", height:"90px"}} />
                </Avatar>

                <div className={styles.loginTitle}>
                    Member Login
                </div>


                <div className={styles.formDiv}>
                    <form onSubmit={onLoginSubmit}>
                        <div className={styles.row}>
                            <input type="text" className={styles.inp} id="email" name="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} style={{width: "90%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none", }} />
                        </div>

                        <div className={styles.row2}>
                            <input type="password" className={styles.inp} id="password" name="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} style={{width: "93%", border: "1px solid #ccc", borderRadius: "0px", resize: "vertical", height: "50px", outline: "none" }} />
                        </div>

                        <div className={styles.row}>
                            <input type="submit" value="Log In" style={{width: "90%", marginLeft: "4%", backgroundColor: "#60c4bc", color:"white", padding: "12px 20px", border: "none", borderRadius: "4px", cursor: "pointer", fontSize: "1.1rem"}}/>
                        </div>
                    </form>
                </div>

                <div className={styles.txt}>Don't Have An Account?</div>
                <div className={styles.decision} onClick={() =>{loginModalOff(); signUpModalOn();}}>Create One</div>
                

                <span className={styles.closeLoginModal} onClick={loginModalOff}>
                    &times;
                </span>
            </div>
        </div>
    )
}

export default LoginModalNew