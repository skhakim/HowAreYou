import React from 'react'
import logo from './logo.png'
import './Header.css'


const Header = ({changeModalFn}) => {
    return (
        <div className='header'>
            <div style={{width: "30%"}}>
                <img src={logo} className="header-logo" alt="logo" />
            </div>

            <div style={{width: "40%"}}>
                <nav>
                    <ul class="nav-links">
                        <li>Home</li>
                        <li>Trends and Statistics</li>
                        <li>About Us</li>
                    </ul>
                </nav>
            </div>

            <div style={{width: "30%"}} className='header-right'>
                <div className='login-btn' onClick={changeModalFn}>
                    Login
                </div>

                <div className='rad-box' onClick={changeModalFn}>
                    TAKE A MENTAL HEALTH TEST
                </div>
            </div>

        </div>
    )
}

export default Header