import React from 'react'
import logo from './logo.png'
import './Header.css'


const Header = ({changeModalFn}) => {
    return (
        <div className='header' style={{backgroundColor: "lavender"}}>
            <div style={{width: "40%"}}>
                <img src={logo} className="header-logo" alt="logo" />
            </div>
            <div style={{width: "30%"}}>
            </div>
            <div className='header-right' style={{width: "40%", display: 'table-caption'}}>
                <nav className='navbar-nav'>
                    <ul class="nav-links" >
                        <li style={{fontSize: 24}}>Home</li>
                        <li style={{fontSize: 24}}>Trends and Statistics</li>
                        <li style={{fontSize: 24}}>About Us</li>
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