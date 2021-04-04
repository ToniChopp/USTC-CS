// Author: wmj
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Com.Glassblade.Group1
{
    public class CaptureGameCtrl : MonoBehaviour
    {
        static public int teamCount=2;
        //scan period
        public float period;
        //score increment per period
        public int increment;
        //win point
        public int win;
        //all points in game
        private OMode[] points;
        //team score
        private int[] score = new int[teamCount];
        
        private float timer;

        private void Start()
        {
            //get all pionts
            points = FindObjectsOfType<OMode>();
            //timer starts
            timer = 0;
            //init 0 points
            for(int i=0;i<score.Length;i++)
            {
                score[i] = 0;
            }
        }

        /// <summary>
        /// scan point every fixed cycle, add score to team
        /// </summary>
        private void Update()
        {
            if((timer+=Time.deltaTime)>=period)
            {
                timer -= period;
                foreach(OMode p in points)
                {
                    if(p.team!=null)
                    {
                        score[(int)p.team] += increment;
                        if (p.team == 0)
                        {
                            GameObject.Find("A Score").GetComponentInChildren<OScoreIncrease>().score = score[(int)p.team];
                        }
                        if (p.team == 1)
                        {
                            GameObject.Find("B Score").GetComponentInChildren<OScoreIncrease>().score = score[(int)p.team];
                        }
                        if (score[(int)p.team]>=win)
                        {
                            GameObject.FindWithTag("Finish").GetComponentInChildren<ODataStore>().Refresh();
                            SceneManager.LoadSceneAsync("ending");
                        }
                    }
                }
            }
        }
    }

}