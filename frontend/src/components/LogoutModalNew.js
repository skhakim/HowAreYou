import React, { useState } from 'react';
import styles from "./newCss/Logout.module.css"
import {useNavigate} from "react-router-dom";
import CloseIcon from '@mui/icons-material/Close';
import Avatar from '@mui/material/Avatar';
import {clearAll} from "./Variables";
import {getToken, setToken, setIdType, setPersonId, setUsername, getIdType} from './Variables.js';

const LogoutModalNew = ({logoutModalOff}) => {
    const navigate = useNavigate();
    return (
        <div className={styles.logoutModal}>
            <div onClick={logoutModalOff} className={styles.logoutOverlay}></div>

            <div className={styles.logoutModalContent}>

                <Avatar className={styles.logoutAvatar} sx={{ bgcolor:"#d46374", width:"100px", height:"100px" }}>
                    <CloseIcon sx={{width:"90px", height:"90px"}} />
                </Avatar>

                <div className={styles.txtOut}>Are You Sure You Want to Log Out?</div>
                <div className={styles.decisionOut} onClick={logoutModalOff}>Go Back</div>

                <div className={styles.formDivOut}>
                    <form onSubmit={() => {clearAll(); navigate("/"); window.location.reload();}}>

                        <div className={styles.rowOut}>
                            <input type="submit" value="Log Out" style={{width: "90%", marginLeft: "4%", backgroundColor: "#d46374", color:"white", padding: "12px 20px", border: "none", borderRadius: "4px", cursor: "pointer", fontSize: "1.1rem"}}/>
                        </div>
                    </form>
                </div>
                
                <span className={styles.closeLogoutModal} onClick={logoutModalOff}>
                    &times;
                </span>
            </div>
        </div>
    )
}

export default LogoutModalNew