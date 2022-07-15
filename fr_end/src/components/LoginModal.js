import React from 'react'
import "./LoginModal.css"
import {useState} from 'react'



const LoginModal = ({changeModalFn, onLogin}) => {

    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')

    const onSubmit = (e) => {
        e.preventDefault()

        if(!email){
            alert("Email should not be empty !!!")
            return
        }

        if(!password){
            alert("Password should not be empty !!!")
            return
        }

        onLogin({email, password})

        setEmail('')
        setPassword('')

        changeModalFn()
    }



    return (
        
        <div className='modal' onSubmit={onSubmit}> 
        

            <form className='modal-content animate'>
                <div className='imgcontainer'>
                    <span className="close" title="Close Modal" onClick={changeModalFn}>&times;</span>
                </div>

                <div className="login-container">
                    <div className='login-label'>LOGIN</div><br />
                    <div className='input-field'><label><b>Email</b></label></div>
                    <input type="text" placeholder="Enter Email" value={email} onChange={(e) => setEmail(e.target.value)} />

                    <div className='input-field'><label><b>Password</b></label></div>
                    <input type="password" placeholder="Enter Password" value={password} onChange={(e) => setPassword(e.target.value)} />

                    <input type="submit" className="login-btn-modal" value="Login" />
                </div>

            </form>
        </div>
    )
}

export default LoginModal