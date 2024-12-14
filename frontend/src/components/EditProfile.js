import React from 'react'
import {useEffect, useState} from 'react'
import {getPersonId, getToken} from "./Variables";
import styles from "./newCss/EditProfile.module.css"
import EditIcon from '@mui/icons-material/Edit';
import DoneIcon from '@mui/icons-material/Done';
import DeleteIcon from '@mui/icons-material/Delete';
import IconButton from '@mui/material/IconButton';
import AddIcon from '@mui/icons-material/Add';

const EditProfile = (props) => {

    const [filled, setFilled] = useState(false);
    const [psyDetail, setPsyDetail] = useState({
        "area_of_expertise": ["Depression", "Somatic Symptoms", "ADHD",],
        "available_hours": ["Monday: 6 PM - 11 PM", "Tuesday: 3 PM - 5 PM", "Thursday: 6 PM - 11 PM"],
        "awards": ["Young Investigators Award - American Psychiatric Association", "Baal er award"],
        "cell": "01911302328",
        "designation": "MBBS[DU]; Residency[Stanford Hospital and Clinics]",
        "email": "najibhaq98@gmail.com",
        "id": 1705044,
        "name": "Najibul Haque Sarker",
    })
    // setPsyDetail(data);

    const psyClicked = async (id) => {
        let details = {}
        await fetchPsychiatristDetails(id).then(
            (data) => {
                details = data
                console.log(data)
                setPsyDetail(data)
                setCell(data.cell)
                setDesignation(data.designation)
                setAwards(data.awards)
                //setAreaOfExpertise(data.area_of_expertise)
                sethours(data.available_hours)
                setFilled(true)
            }
        )

        // const details = {
        //     "id":1,
        //     "name":"MA. Adnan Rahman",
        //     "designation": "Cancer Specialist",
        //     "cell": 42042069,
        //     "email": "johndoe@gmail.com",
        //     "area_of_expertise":[
        //       "cancer", "skin", "bone"
        //     ],
        //     "awards": [
        //       "some random award",
        //       "random award with too big name random award with too big name random award with too big name"
        //     ],
        //     "available_hours" : [
        //       {"id":1, "datetime":"Monday 6pm - 8pm"},
        //       {"id":2, "datetime":"Tuesday 7pm - 10pm"},
        //       {"id":3, "datetime":"Wednesday 6pm - 8pm"},
        //       {"id":4, "datetime":"Friday 5pm - 9pm"}
        //     ]
        // }

        console.log(details)
    }

    const fetchPsychiatristDetails = async (id) => {
        const res = await fetch('/pd/' + id)
        console.log("res", res)
        const data = await res.json()
        console.log("Data", data)
        return data
    }

    const [designation, setDesignation] = useState(psyDetail.designation)
    const [editDesignationModal, setEditDesignationModal] = useState(false)

    const [cell, setCell] = useState(psyDetail.cell)
    const [editCellModal, setEditCellModal] = useState(false)

    const [awards, setAwards] = useState(psyDetail.awards)
    const [editAwards, setEditAwards] = useState(false)
    const [newAward, setNewAward] = useState("")

    const [hours, sethours] = useState(psyDetail.available_hours)
    const [editHours, setEditHours] = useState(false)
    const [newHour, setNewHour] = useState("")

    const removeAward = (award) => {
        var temp = awards.filter(opt => opt !== award)
        setAwards(temp)
    }
    const newAwardAdded = () => {

        if (!newAward) {
            alert("Award Field Empty")
            return
        }


        var index = 0;
        while (index < awards.length) {
            if (awards[index] === newAward) {
                alert("Award Already Exists. Try New one")
                index++
                return
            }
            index++;
        }
        var temp = [...awards, newAward]
        setAwards(temp)
        setEditAwards(false)
        setNewAward("")
    }


    const removeHour = (hour) => {
        var temp = hours.filter(opt => opt !== hour)
        sethours(temp)
    }
    const newHourAdded = () => {

        if (!newHour) {
            alert("Time Field Empty")
            return
        }

        var index = 0;
        while (index < hours.length) {
            if (hours[index] === newHour) {
                alert("Time Already Exists. Try New one")
                index++
                return
            }
            index++;
        }
        var temp = [...hours, newHour]
        sethours(temp)
        setEditHours(false)
        setNewHour("")
    }

    const uploadChanges = async () => {
        var changedData = {}
        changedData["area_of_expertise"] = psyDetail["area_of_expertise"]
        changedData["available_hours"] = hours
        changedData["awards"] = awards
        changedData["cell"] = cell
        changedData["designation"] = designation
        changedData["email"] = psyDetail["email"]
        changedData["id"] = psyDetail["id"]
        changedData["name"] = psyDetail["name"]


        console.log(changedData)

        const res = await fetch('/change_profile',
            {
                'method': 'POST', 'headers': {'Content-Type': 'application/json', 'x-access-token': getToken()},
                'body': JSON.stringify(changedData)
            }).then(r => console.log("R", r))
    }

    if (!filled)
        psyClicked(props.id === undefined ? psyClicked(getPersonId()) : psyClicked(props.id)).then();

    const approvePsychiatrist = async (id) => {
        const res = await fetch('/psy_app/' + id,
            {
                'method': 'POST', 'headers': {'Content-Type': 'application/json', 'x-access-token': getToken()}
            })
        const data = await res.json()
        console.log(data)
        if(data.response === 'success'){
            alert('Psychiatrist Approved')
        } else {
            alert('Please try again')
        }
    }


    const declinePsychiatrist = async (id) => {
        const res = await fetch('/psy_dec/' + id,
            {
                'method': 'POST', 'headers': {'Content-Type': 'application/json', 'x-access-token': getToken()}
            })
        const data = await res.json()
        console.log(data)
        if(data.response === 'success'){
            alert('Psychiatrist Declined Access')
        } else {
            alert('Please try again')
        }
    }


    return (
        <div className={styles.ct}>
            {/*<button onClick={() => psyClicked(getPersonId())}> <label>yeyhe u</label></button>*/}
            <div className={styles.detailContainerPro}>
                {/*{console.log("PD: ", psyDetail)}*/}
                <div className={styles.docNameModalPro}>
                    {(props.id===undefined) ? <></> : <h3>Signup Review Request for </h3>}
                    <h2>Dr. {psyDetail.name}</h2>
                </div>
                <hr className='line-psy' style={{width: "70%"}}></hr>

                <div className={styles.flexboxPro}>
                    <div className={styles.leftFlexPro}>
                        <img src="https://picsum.photos/200"/>

                        <div className={styles.designationPro}>
                            {/*{*/}
                            {/*    editDesignationModal ? (*/}
                            {/*        <>*/}
                            {/*            <div style={{width:"80%", marginRight:"5%", marginLeft:"40px"}}>*/}
                            {/*                <textarea rows={2} cols={40} style={{resize:"none"}} value={designation} onChange={(e) => setDesignation(e.target.value)} />*/}
                            {/*            </div>*/}
                            {/*            <DoneIcon onClick={() => setEditDesignationModal(false)} sx={{fontSize:"0.9rem", mt:1, "&:hover":{cursor:"pointer"}}}/>*/}
                            {/*        </>*/}
                            {/*    ):(*/}
                            {/*        <>*/}
                            {/*            <div style={{width:"80%", marginRight:"5%", marginLeft:"40px"}}>{designation}</div>*/}
                            {/*            <EditIcon onClick={() => setEditDesignationModal(true)} sx={{fontSize:"0.9rem", mt:1, "&:hover":{cursor:"pointer"} }} />*/}
                            {/*        </>*/}
                            {/*    )*/}
                            {/*}*/}

                            {psyDetail.designation}
                        </div>

                        <div className={styles.cellPro}>Certificate: {psyDetail.cert}</div> <br/> 

                        <div style={{display: "flex"}} className={styles.cellPro}>
                            {(props.id === undefined) ?
                                editCellModal ? (
                                    <>
                                        <div style={{width: "60%", marginRight: "5%"}}>
                                            Cell: <input style={{width: "170px"}} type="text" value={cell}
                                                         onChange={(e) => setCell(e.target.value)}/>
                                        </div>
                                        <DoneIcon onClick={() => setEditCellModal(false)} sx={{
                                            fontSize: "0.9rem",
                                            fontWeight: "500",
                                            mt: 1.5,
                                            "&:hover": {cursor: "pointer"}
                                        }}/>
                                    </>
                                ) : (
                                    <>
                                        <div style={{width: "50%", marginRight: "5%"}}>Cell: {cell}</div>
                                        <EditIcon onClick={() => setEditCellModal(true)}
                                                  sx={{fontSize: "0.9rem", mt: "5px", "&:hover": {cursor: "pointer"}}}/>
                                    </>
                                )
                                : <>Cell: {psyDetail.cell}</>}

                        </div>
                        <br/>
                        <div className={styles.cellPro}>Email: {psyDetail.email}</div>
                    </div>

                    <div className={styles.middleFlexPro}>
                    </div>

                    <div className={styles.rightFlexPro}>
                        <b>AREAS OF EXPERTISE</b>
                        <hr className='line-psy' style={{width: "90%"}}></hr>

                        {
                            psyDetail['area_of_expertise'].map(
                                (area) => (
                                    <label style={{marginLeft: "50px"}} className="ckbox-container-show">{area}
                                        <input type="checkbox" value={area} disabled/>
                                        <span className="ckbox-checkmark-show"></span>
                                    </label>
                                )
                            )
                        }

                        {/* <ul>
                            {
                                psyDetail['area_of_expertise'].map(
                                    (area) => <li className={styles.cellPro}>{area}</li>
                                )
                            }
                        </ul> */}

                        <div style={{display: "flex", marginTop: "20px"}}>
                            <div><b>HONORS and AWARDS</b></div>
                            {
                                (props.id === undefined) ?
                                (!editAwards && (
                                    <div onClick={() => {setEditAwards(true); }} className={styles.addNewOption}>
                                        <div style={{marginLeft:"4px"}}>Add Award</div>
                                    </div>
                                )) : <></>
                            }
                        </div>
                        <hr className='line-psy' style={{width: "90%"}}></hr>
                        {
                            awards.map(
                                (award) => (
                                    <div style={{marginLeft: "0px", display: "flex"}} className='optionContainer'>
                                        <label style={{marginLeft: "50px", marginRight: "50px"}}
                                               className="ckbox-container-show">{award}
                                            <input type="checkbox" value={award} disabled/>
                                            <span className="ckbox-checkmark-show"></span>
                                        </label>
                                        {/*<IconButton onClick={() => removeAward(award)} sx={{mt:"-10px", '&:hover':{backgroundColor: '#a39d9d',}}}> <DeleteIcon sx={{ color:"#f03224"}} /> </IconButton>*/}
                                    </div>
                                )
                            )
                        }
                        {
                            editAwards && (
                                <div>

                                    <div style={{display: "flex", marginLeft: "50px"}}>

                                        <input style={{"marginLeft": "0%", "width": "50%", borderRadius: "4px"}} type="text"
                                               placeholder="name of the award;the institution who gave the award" value={newAward}
                                               onChange={(e) => setNewAward(e.target.value)}/>

                                        <div style={{marginLeft: "2%", marginTop: "22px"}} className={styles.saveBtn}
                                             onClick={() => newAwardAdded()}>
                                            Save
                                        </div>

                                        <div style={{marginLeft: "1%", marginTop: "22px"}} className={styles.cancelBtn}
                                             onClick={() => {
                                                 setEditAwards(false);
                                                 setNewAward("");
                                             }}>
                                            Cancel
                                        </div>

                                    </div>

                                </div>
                            )
                        }


                        {/* Available Hours                                   */}

                        <div style={{display: "flex", marginTop: "20px"}}>
                            <div><b>AVAILABLE HOURS</b></div>
                            {(props.id === undefined) ?
                                !editHours && (
                                    <div onClick={() => {
                                        setEditHours(true);
                                    }} className={styles.addNewOption}>
                                        <div style={{marginLeft: "4px"}}>Add Time</div>
                                    </div>
                                ) : <></>
                            }
                        </div>
                        <hr className='line-psy' style={{width: "90%"}}></hr>
                        {
                            hours.map(
                                (hour) => (
                                    <div style={{marginLeft: "0px", display: "flex"}} className='optionContainer'>
                                        <label style={{marginLeft: "50px", marginRight: "50px"}}
                                               className="ckbox-container-show">{hour}
                                            <input type="checkbox" value={hour} disabled/>
                                            <span className="ckbox-checkmark-show"></span>
                                        </label>
                                        {(props.id === undefined) ?
                                            <IconButton onClick={() => removeHour(hour)}
                                                        sx={{mt: "-10px", '&:hover': {backgroundColor: '#a39d9d',}}}>
                                                <DeleteIcon sx={{color: "#f03224"}}/> </IconButton> : <></>}
                                    </div>
                                )
                            )
                        }
                        {
                            editHours && (
                                <div>

                                    <div style={{display: "flex", marginLeft: "50px"}}>

                                        <input style={{"marginLeft": "0%", "width": "50%", borderRadius: "4px"}} type="text"
                                               placeholder="Date: Time Slot" value={newHour}
                                               onChange={(e) => setNewHour(e.target.value)}/>

                                        <div style={{marginLeft: "2%", marginTop: "22px"}} className={styles.saveBtn}
                                             onClick={() => newHourAdded()}>
                                            Save
                                        </div>

                                        <div style={{marginLeft: "1%", marginTop: "22px"}} className={styles.cancelBtn}
                                             onClick={() => {
                                                 setEditHours(false);
                                                 setNewHour("");
                                             }}>
                                            Cancel
                                        </div>

                                    </div>

                                </div>
                            )
                        }


                        {/* <b>Available Hours</b>
                        <hr className='line-psy' style={{width:"90%"}}></hr>
                        <form >
                            {
                                psyDetail.available_hours.map(
                                    (available) => (
                                        <div className={styles.optionContainerPro} >
                                            <input type="radio" className={styles.radioPro} name="selectTime" value={available} />
                                            <label align={"left"}>{available}</label>
                                        </div>
                                    )
                                )
                            }
                            <button type="submit" className={styles.btnBtn}>Send </button>
                        </form> */}


                    </div>

                </div>
            </div>

            {
                (props.id === undefined) ?
                    <div className='done-btn' onClick={() => uploadChanges()}>
                        Upload Changes
                    </div> : <>
                        <div className='done-btn3' onClick={() => approvePsychiatrist(props.id)}>
                            Approve
                        </div>
                        <div className='done-btn3' onClick={() => declinePsychiatrist(props.id)}>
                            Decline
                        </div>
                    </>
            }
        </div>
    )
}

export default EditProfile