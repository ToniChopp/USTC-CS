//Author: David Wang


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Com.Glassblade.Group1
{
    public class OCameraFollow : MonoBehaviour
    {
        //玩家
        private Transform PlayerTrans;
        //相机高度
        public float Camera_Height;
        //相机距离
        public float Camera_Distance;
        //队伍
        public int team;


        void Start()
        {
            //获取玩家角色
            GameObject player = GameObject.FindGameObjectWithTag("Player");
            // 获取Player位置
            this.PlayerTrans = player.transform;
            //获取队伍
            team = player.GetComponent<OCharacterBehavior>().team;
        }


        void Update()
        {
            // 跟随Player
            this.transform.position = new Vector3(this.PlayerTrans.position.x, this.PlayerTrans.position.y + 
                this.Camera_Height, this.PlayerTrans.position.z - this.Camera_Distance);
            // 对准Player
            this.transform.LookAt(this.PlayerTrans);
        }
    }
}