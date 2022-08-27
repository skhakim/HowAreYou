import React from 'react'
import styles from "./newCss/Notification.module.css"
import {getToken, setToken, setIdType, setPersonId, setUsername, getIdType} from './Variables.js';
import {useEffect, useState} from 'react'
import Avatar from '@mui/material/Avatar';
import {useNavigate} from "react-router-dom";

const NotificationModal = ({notificationModalOff, setNumber}) => {
    const [notificationList, setNotificationList] = useState([])
    const navigate = useNavigate()

    useEffect(() => {
        const getResponse = async () => {
            // change here
            const notiFromServer = await fetchNotifications()

            // const data = [
            //     {
            //         "from":"Najibul Haque Sarker",
            //         "text":"Your Request has been accepted",
            //         "url":""
            //     },
            //     {
            //         "from":"System",
            //         "text":"Your Request has been denied",
            //         "url":""
            //     },
            //     {
            //         "from":"Iftekhar Hakim Kaowsar",
            //         "text":"Your are dead",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            //     {
            //         "from":"Apurba Saha",
            //         "text":"Sent You a meassage",
            //         "url":""
            //     },
            // ]

            setNotificationList(notiFromServer)
        }
        getResponse()

    }, [])

    const fetchNotifications = async () => {
        const res = await fetch('/view_notifications', {
            method: "GET", headers: {
                'Accept': 'application/vnd.api+json'
                , 'x-access-token': getToken()
            }
        })
        const data = await res.json()
        setNumber(data.number)
        return data.notifications
    }


    const nav = (notification) => {
        console.log("It comes here", notification.from)
        if (notification.from === "C") {
            console.log("Here too")
            navigate('/list_appointment_requests')
        } else if (notification.from === "U") {
            navigate('/list_files_req')
        } else if (notification.from === "V") {
            navigate('/show_verified_reports')
        }
        notificationModalOff()
    }

    return (
        <div className={styles.modalNoti}>
            <div onClick={notificationModalOff} className={styles.overlayNoti}></div>

            <div className={styles.modalContentNoti}>
                <div style={{height: "5px"}}></div>
                <div className={styles.notiHeader}>
                    <span style={{fontSize: "1.1rem"}}><b>Notifications</b></span>
                    <span onClick={async () => {
                        notificationModalOff();
                        await fetch('/mark_notifications/', {
                            method: "POST",
                            headers: {'Accept': 'application/vnd.api+json', 'x-access-token': getToken()}
                        }).then()
                    }} style={{fontSize: "1.1rem", float: "right", textDecoration: "underline", cursor: "pointer"}}> Mark read</span>
                </div>

                <div className={styles.detailContainerNoti}>
                    <hr className={styles.linePsy}></hr>
                    {
                        notificationList.map(
                            (notification) => (
                                <>
                                    <div className={styles.eachNoti}>
                                        <div className={styles.leftNoti}>
                                            <Avatar onClick={() => nav(notification)}
                                                    sx={{
                                                        border: 1,
                                                        borderColor: "black",
                                                        bgcolor: (!notification.seen) ? '#ff00ff' : '#c0c0c0'
                                                    }}>
                                                {notification.from.charAt(0)}</Avatar>
                                        </div>

                                        <div className={styles.rightNoti} onClick={() => nav(notification)}>
                                            {(!notification.seen) ? <b>{notification.text}</b>
                                                : <span>{notification.text}</span>}
                                        </div>
                                    </div>

                                    <hr className={styles.linePsy}></hr>
                                </>
                            )
                        )
                    }
                </div>

            </div>
        </div>
    )
}

export default NotificationModal