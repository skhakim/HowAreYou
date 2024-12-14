import React from 'react'
import "./LoginModal.css"
import {clearAll} from "./Variables";
import {useNavigate} from "react-router-dom";

const LogoutModal = ({cngLogoutModalFn}) => {

    const navigate = useNavigate();
    return (
        <div className='modal'>
            <form className='modal-content animate'>
                <div className='imgcontainer'>
                    <span className="close" title="Close Modal" onClick={cngLogoutModalFn}>&times;</span>
                </div>
                <div className="login-container">
                    <input type="submit" className="login-btn-modal" value="Logout" onClick={() => {
                        clearAll()
                        navigate('/')
                        window.location.reload();
                    }} />
                </div>

            </form>
        </div>
    )
}

export default LogoutModal