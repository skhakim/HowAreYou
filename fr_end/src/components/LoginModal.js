import React from 'react'
import "./LoginModal.css"


const LoginModal = ({show, changeModalFn}) => {
    return (
        
        <div className='modal'>
            <form className='modal-content animate'>
                <div className='imgcontainer'>
                    <span className="close" title="Close Modal" onClick={changeModalFn}>&times;</span>
                </div>

                <div className="login-container">
                    <div className='login-label'>LOGIN</div><br />
                    <div className='input-field'><label><b>Username</b></label></div>
                    <input type="text" placeholder="Enter Username" name="username" />

                    <div className='input-field'><label><b>Password</b></label></div>
                    <input type="password" placeholder="Enter Password" name="password" />

                    <input type="submit" className="login-btn-modal" value="Login" />
                </div>

            </form>

        </div>
    )
}

export default LoginModal