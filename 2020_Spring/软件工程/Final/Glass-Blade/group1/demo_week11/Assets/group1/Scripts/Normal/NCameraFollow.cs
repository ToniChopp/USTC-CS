//Author: David Wang


using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Com.Glassblade.Group1
{
    public class NCameraFollow : MonoBehaviour
    {
        private Transform PlayerTrans;
        // 相机高度
        public float Camera_Height = 25;
        // 相机距离
        public float Camera_Distance = 25;
        // 队伍
        public int team;
        //获取玩家角色
        public GameObject player;

        void Start()
        {
            // 获取Player位置
            this.PlayerTrans = player.transform;
            //获取队伍
            team = player.GetComponent<NCharacterBehavior>().team;
        }

        void Update()
        {
            // 跟随Player
            this.transform.position = new Vector3 (this.PlayerTrans.position.x, this.PlayerTrans.position.y + this.Camera_Height, 
                this.PlayerTrans.position.z - this.Camera_Distance);
            // 对准Player
            this.transform.LookAt (this.PlayerTrans);
        }
    }
}
