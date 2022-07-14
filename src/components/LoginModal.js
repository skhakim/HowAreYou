import React from 'react'
import "./LoginModal.css"



        // <div id="login-modal-id" class="modal">
        //     <form class="modal-content animate" action="{% url 'persons:login' %}" method="post">
        //         {% csrf_token %}
        //         <div class="imgcontainer">
        //             <span onclick="document.getElementById('login-modal-id').style.display='none'" class="close" title="Close Modal">&times;</span>
        //         </div>
      
                // <div class="login-container">
                //     <div style="display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: bold;">LOGIN</div>
                //     <label><b>Username</b></label>
                //     <input type="text" placeholder="Enter Username" name="username">
      
                //     <label><b>Password</b></label>
                //     <input type="password" placeholder="Enter Password" name="password">
      
                //     <input type="submit" class="login-btn" value="Login" style="background: none; border: none; background-color: #ddd; margin-top: 8px; padding: 11px; border-radius: 10px; width: 100%;">
                // </div>
      
        //         <div class="login-container" style="background-color:#f1f1f1">
        //             <div style="display: flex; align-items: center; justify-content: center;"><span>No account? <a href="#"> Create one</a></span></div>
        //         </div>
        //     </form>
        // </div>

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

            {/* <form className='modal-content'>

                <div className='imgcontainer'>
                    <span class="close" title="Close Modal">&times;</span>
                </div>

                <div className="login-container">
                    <div style="display: flex; align-items: center; justify-content: center; font-size: 1.1rem; font-weight: bold;">LOGIN</div>
                    <label><b>Username</b></label>
                    <input type="text" placeholder="Enter Username" name="username" />
      
                    <label><b>Password</b></label>
                    <input type="password" placeholder="Enter Password" name="password" />
      
                    <input type="submit" className="login-btn" value="Login" style="background: none; border: none; background-color: #ddd; margin-top: 8px; padding: 11px; border-radius: 10px; width: 100%;" />
                </div>

            </form> */}
        </div>
    )
}

export default LoginModal