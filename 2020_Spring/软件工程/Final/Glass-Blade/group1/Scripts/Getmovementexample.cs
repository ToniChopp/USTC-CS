//Author: wmj


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//nothing
public class Getmovementexample : MonoBehaviour
{
    public Joystick ctrl;
    // Update is called once per frame
    void Update()
    {
        Debug.Log(ctrl.Movement);
    }
}
