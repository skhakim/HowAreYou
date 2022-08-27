import React, {useState} from 'react'
import logo from './logo.png'
// import './Header.css'
// import styles from "./Header.css"
import {FaThumbsUp, FaThumbsDown, FaCheck, FaBan} from 'react-icons/fa'
import {getIdType, getUsername} from "./Variables";
import {useNavigate} from "react-router-dom";




import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import IconButton from '@mui/material/IconButton';
import Typography from '@mui/material/Typography';
import Menu from '@mui/material/Menu';
import MenuIcon from '@mui/icons-material/Menu';
import Container from '@mui/material/Container';
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import Tooltip from '@mui/material/Tooltip';
import MenuItem from '@mui/material/MenuItem';
import AdbIcon from '@mui/icons-material/Adb';
import useScrollTrigger from '@mui/material/useScrollTrigger';
import Slide from '@mui/material/Slide';
import PropTypes from 'prop-types';
import Badge from '@mui/material/Badge';
import NotificationsIcon from '@mui/icons-material/Notifications';
import LoginModalNew from './LoginModalNew';
import SignupModalNew from './SignupModalNew';
import LogoutModalNew from './LogoutModalNew';
import NotificationModal from './NotificationModal';


function HideOnScroll(props) {
    const { children, window } = props;
    const trigger = useScrollTrigger({
        target: window ? window() : undefined,
    });
  
    return (
        <Slide appear={false} direction="down" in={!trigger}>
            {children}
        </Slide>
    );
}
  
HideOnScroll.propTypes = {
    children: PropTypes.element.isRequired,
    window: PropTypes.func,
};




const Header = ({changeLoginModalFn, loggedIn, cngLogoutModalFn}) => {
    const navigate = useNavigate();
    const [showNotificationModal, setShowNotificationModal] = useState(false)
    const [showRequestModal, setShowRequestModal] = useState(false)
    const [showNotificationList, setShowNotificationList] = useState(false)


    const [requestList, setRequestList] = useState([])
    const [patientNotifications, setPatientNotifications] = useState([])

    //const [isPatient, setIsPatient] = useState(false)

    const [loginModalActive, setLoginModalActive] = useState(false);
    const [signUpModalActive, setSignUpModalActive] = useState(false);
    const [logoutModalActive, setLogoutModalActive] = useState(false);


    const notificationClicked = (type) => {
        if (type === "CR") {
            setShowNotificationModal(false)

            // const requests =
            fetchConsulationRequest().then((requests) => setRequestList(requests.consultation_requests))
            setShowRequestModal(true)
        }
    }


    const typeOfNotificationClicked = (type) => {
        if (type === "consultancyRequest") {
            setShowNotificationModal(false)

            // const requests = fetchConsulationRequest(id)

            const requests = [
                {"id": 1, "name": "Zaber", "time": "Sunday 8PM"},
                {"id": 2, "name": "Ifto", "time": "Sunday 8PM"},
                {"id": 3, "name": "Apurba", "time": "Sunday 8PM"},
                {"id": 4, "name": "Fahim", "time": "Sunday 8PM"}
            ]

            setRequestList(requests)
            setShowRequestModal(true)
        } else if (type === "reviewQuesUpdate") {
            console.log("Redirect to the page where update requests are listed")

        }
    }
    const patientConsultationButtonClicked = () => {
        if (getIdType() === 'patient_id') {
            fetchConsulationRequestPatient().then((notifications) => {
                console.log(notifications)
                setPatientNotifications(notifications.consultation_requests)
                setShowNotificationList(true)
            })
        } else {
            setShowNotificationModal(!showNotificationModal)
        }

    }

    const fetchConsulationRequest = async () => {
        const data = await fetch('/view_consultation_request', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then(res => res.json())
        //const data = await res.json()
        return data
    }

    const fetchConsulationRequestPatient = async () => {
        const data = await fetch('/consultation_requests', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then(res => res.json())
        //const data = await res.json()
        return data
    }


    const acceptConsultationRequest = async (id) => {
        const data = await fetch('/accept_consultation_request/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then()
        notificationClicked("CR")
        alert("Patient will be notified")
    }

    const deleteConsultationRequest = async (id) => {
        const data = await fetch('/delete_consultation_request/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then()
        fetchConsulationRequest() // refresh the list
        window.location.reload()
    }

    /////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////

    const [anchorElNav, setAnchorElNav] = React.useState(null);
    const [anchorElUser, setAnchorElUser] = React.useState(null);

    const handleOpenNavMenu = (event) => {
        setAnchorElNav(event.currentTarget);
    };
    const handleOpenUserMenu = (event) => {
        setAnchorElUser(event.currentTarget);
    };

    const handleCloseNavMenu = () => {
        setAnchorElNav(null);
    };

    const handleCloseUserMenu = () => {
        setAnchorElUser(null);
    };

    ////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////

    return (
        <>
            {/*<div className='header'>
                <div style={{width: "30%"}}>
                    <img src={logo} className="header-logo" alt="logo"/>
                </div>

                <div style={{width: "40%"}}>
                    <nav>
                        <ul className="nav-links">
                            <li>Home</li>
                            <li>Trends and Statistics</li>
                            <li>About Us</li>
                        </ul>
                    </nav>
                </div>

                <div style={{width: "30%"}} className='header-right'>
                    {loggedIn ? (<div className='rad-box-name' onClick={cngLogoutModalFn}> {getUsername()}</div>) : (
                        <div className='login-btn' onClick={() => {
                            navigate('/login')
                        }}> Login</div>)}

                    {loggedIn ? (<div className='rad-box'
                                      onClick={() => setShowNotificationModal(!showNotificationModal)}>NOTIFICATION</div>) : (
                        <div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}


                    {loggedIn ? (<div className='rad-box' onClick={() => notificationButtonClicked() }>NOTIFICATION</div>) : (<div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}


                    {loggedIn ? (<div className='rad-box'>NOTIFICATION</div>) : (<div className='rad-box' onClick={changeLoginModalFn}> TAKE A MENTAL HEALTH TEST</div>)}
                </div>

            </div>*/}

            <HideOnScroll >
            <AppBar position="sticky" enableColorOnDark={true} sx={{bgcolor:"#5F9EA0"}}>
                <Container maxWidth="xl">
                    <Toolbar disableGutters>
                        
                        <img src={logo} style={{borderRadius:0, height:"70px", width:"200px", marginBottom:0}} />

                        <Box sx={{ flexGrow: 1, display: { xs: 'flex', md: 'none' }, }}>
                            <IconButton size="large" aria-label="account of current user" aria-controls="menu-appbar" aria-haspopup="true" onClick={handleOpenNavMenu} color="inherit">
                                <MenuIcon />
                            </IconButton>
                            <Menu id="menu-appbar" anchorEl={anchorElNav} anchorOrigin={{vertical: 'bottom',horizontal: 'left',}} keepMounted transformOrigin={{vertical: 'top',horizontal: 'left',}} open={Boolean(anchorElNav)} onClose={handleCloseNavMenu} sx={{display: { xs: 'block', md: 'none' },}}>
                            
                                <MenuItem key="PRODUCTS" onClick={handleCloseNavMenu}>
                                    <Typography textAlign="center" >PRODUCTS</Typography>
                                </MenuItem> 

                                <MenuItem key="PRICING" onClick={handleCloseNavMenu}>
                                    <Typography textAlign="center">PRICING</Typography>
                                </MenuItem>   

                                <MenuItem key="BLOG" onClick={handleCloseNavMenu}>
                                    <Typography textAlign="center">BLOG</Typography>
                                </MenuItem>     
              
                            </Menu>
                        </Box>

                        <AdbIcon sx={{ display: { xs: 'flex', md: 'none' }, mr: 1 }} />
                        <Typography variant="h5" noWrap component="a" href="" sx={{ mr: 2, display: { xs: 'flex', md: 'none' }, flexGrow: 1, fontFamily: 'monospace', fontWeight: 700, letterSpacing: '.3rem', color: 'inherit', textDecoration: 'none',}}>
                            LOGO
                        </Typography>
                        <Box sx={{ flexGrow: 1, display: { xs: 'none', md: 'flex' }, ml:10 }}>             
                            <Button key="PRODUCTS" onClick={() => {
                                handleCloseNavMenu();
                                getIdType() === 'psychiatrist_id' ? navigate('/psyhome') : navigate('/tests')}
                            } sx={{ my: 2, color: 'black', display: 'block', '&:hover':{backgroundColor: '#9dd2d4',} }}>
                                Home
                            </Button>
                            <Button key="PRICING" onClick={handleCloseNavMenu} sx={{ my: 2, color: 'black', display: 'block', ml:3, '&:hover':{backgroundColor: '#9dd2d4',} }}>
                                Trends
                            </Button>
                            <Button key="BLOG" onClick={() => {
                                handleCloseNavMenu();
                                navigate('/')
                            }} sx={{ my: 2, color: 'black', display: 'block', ml:3, '&:hover':{backgroundColor: '#9dd2d4',} }}>
                                About Us
                            </Button>
            
                        </Box>

                        <Box sx={{ flexGrow: 0 }}>

                            {loggedIn ? 
                                (
                                    <>
                                        <Tooltip>
                                            {showNotificationList ? 
                                                (
                                                    <>
                                                        <IconButton size="large" aria-label="new notifications" color="inherit" onClick={() => {setShowNotificationList(true)}} sx={{bgcolor:"#b5b5b5"}}>
                                                            <Badge badgeContent={17} color="error">
                                                                <NotificationsIcon color='secondary' />
                                                            </Badge>
                                                        </IconButton>
                                                    </>
                                                ): 
                                                (
                                                    <>
                                                        <IconButton size="large" aria-label="new notifications" color="inherit" onClick={() => {setShowNotificationList(true)}}>
                                                            <Badge badgeContent={17} color="error">
                                                                <NotificationsIcon color='secondary' />
                                                            </Badge>
                                                        </IconButton>
                                                    </>
                                                )
                                            }
                                            
                                        </Tooltip>

                                        <Tooltip title="Open settings" >
                                            <IconButton onClick={handleOpenUserMenu} sx={{ p: 0, ml:5 }}>
                                                <Avatar sx={{border:2, borderColor:"black", bgcolor:"#FF7F50"}}>{getUsername().charAt(0)}</Avatar>
                                            </IconButton>
                                        </Tooltip>
                                    </>
                                ):
                                (
                                    <Button onClick={() => {setLoginModalActive(true)}} key="takeTest" sx={{ my: 2, color: 'black', display: 'block', '&:hover':{backgroundColor: '#9dd2d4',} }}>
                                        Sign In
                                    </Button> 
                                )
                            }

                            <Menu sx={{ mt: '45px' }} id="menu-appbar" anchorEl={anchorElUser} anchorOrigin={{ vertical: 'top', horizontal: 'right',}} keepMounted transformOrigin={{ vertical: 'top', horizontal: 'right',}} open={Boolean(anchorElUser)} onClose={handleCloseUserMenu}>
                      
                                <MenuItem key="Profile" onClick={ () => {handleCloseUserMenu(); navigate("/edit_profile")} }>
                                    <Typography textAlign="center">Profile</Typography>
                                </MenuItem>
                                <MenuItem key="Logout" onClick={() => {handleCloseUserMenu(); setLogoutModalActive(true); }}>
                                    <Typography textAlign="center">Logout</Typography>
                                </MenuItem>
              
                            </Menu>
                        </Box>
                    </Toolbar>
                </Container>
            </AppBar>
            </HideOnScroll>
            
            {
                loginModalActive && (
                    <LoginModalNew  loginModalOff={()=> setLoginModalActive(false)} signUpModalOn={()=> setSignUpModalActive(true)} />
                )
            }

            {
                signUpModalActive && (
                    <SignupModalNew loginModalOn={() => setLoginModalActive(true)} signUpModalOff={() => setSignUpModalActive(false)}/>
                )
            }

            {
                logoutModalActive && (
                    <LogoutModalNew logoutModalOff={() => setLogoutModalActive(false)} />
                )
            }

            {
                showNotificationList && (
                    <NotificationModal notificationModalOff={() => {setShowNotificationList(false)}} />
                )
            }

            {/* {
                showNotificationModal && (
                    <div className='modal1'>
                        <div onClick={() => setShowNotificationModal(false)} className="overlay1"></div>

                        <div className="modal-content1">
                            <div className='detailContainer1'>
                                {!(getIdType() === 'patient_id') ? <>
                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                    <div className='task' onClick={() => notificationClicked("CR")}>
                                        Consultation Request
                                    </div>

                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                    <div className='task' onClick={() => typeOfNotificationClicked("reviewQuesUpdate")}>
                                        Review Questionnaire Update
                                    </div>

                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                    <div className='task'>
                                        Task 3
                                    </div>
                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                </> : <>
                                    <div className='task' onClick={() => patientConsultationButtonClicked()}>
                                        Check Approved Consultation Requests List
                                    </div>
                                    <hr className='line-psy' style={{width: "100%"}}></hr>
                                </>}
                            </div>

                        </div>
                    </div>
                )
            } */}

            {
                showRequestModal && (
                    <div className='modal1'>
                        <div onClick={() => setShowRequestModal(false)} className="overlay1"></div>

                        <div className="modal-content2">
                            <div className='detailContainer1'>
                                {
                                    console.log("Request list", requestList)}{
                                requestList.map(
                                    (request) => (
                                        request.approved ? (<> </>) :
                                            (<>
                                                <div className='requestItem'>
                                                    <div className='leftItem'>
                                                        {request.name} wanted to request consultancy at {request.time}
                                                    </div>

                                                    <div className='rightItem'>
                                                        <FaCheck className="icon1" style={{"margin-right": "25%"}}
                                                                 onClick={() => acceptConsultationRequest(request.id)}/>
                                                        <FaBan className="icon2"
                                                               onClick={() => deleteConsultationRequest(request.id)}/>
                                                    </div>

                                                </div>
                                                <hr className='line-psy' style={{width: "100%"}}></hr>
                                            </>)
                                    )
                                )
                            }
                            </div>

                        </div>
                    </div>
                )
            }

            {/* {
                showNotoficationList && (
                    <div className='modal1'>
                        <div onClick={() => setShowNotificationList(false)} className="overlay1"></div>
                        <div className='modal-content2'>
                            <div className='detailContainer1'>
                                {
                                    patientNotifications.map(
                                        (notification) => (
                                            <>
                                                <div className='requestItem'>
                                                    {notification.text}
                                                </div>
                                                <hr className='line-psy' style={{width: "100%"}}></hr>
                                            </>
                                        )
                                    )
                                }
                            </div>
                        </div>
                    </div>
                )
            } */}
        </>

    )
}

export default Header