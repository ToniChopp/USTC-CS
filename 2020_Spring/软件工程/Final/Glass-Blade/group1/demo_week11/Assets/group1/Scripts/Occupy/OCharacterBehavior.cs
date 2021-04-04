using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace Com.Glassblade.Group1
{
    public class OCharacterBehavior : MonoBehaviour
    {
        //队伍
        public int team;
        //角色，名字渲染
        Renderer[] character, namebar;
        //血条渲染
        CanvasRenderer[] healthbar;
        //虚拟摇杆
        public OJoystick touch;
        //速度
        public float speed = 10;
        //动画
        private Animator ani;
        //击杀数
        [HideInInspector]
        public int killTime = 0;
        //死亡数
        [HideInInspector]
        public int deathTime = 0;
        //个人得分
        [HideInInspector]
        public int score = 0;
        //技能序号
        [SerializeField]
        private int skillNumber;
        //Author: wmj
        //死亡事件
        public DeathEvent deathevent = new DeathEvent();
        //隐身技能生效时间
        public float invisibleDuration = 8;
        //隐身技能剩余时间
        private float invisibleTime = 0;
        //突进技能时间
        private double marchForwardTime = 0;
        //突进距离
        [SerializeField]
        private float distance = 5;
        //加速技能持续时间
        [SerializeField]
        private float accelerateDuration = 5;
        //加速技能剩余时间
        private float accelerateTime = 0;
        //加速幅度
        [SerializeField]
        private float speedUp = 0.8F;
        //无敌技能持续时间
        [SerializeField]
        private float unbeatableDuration = 2;
        //无敌技能剩余时间
        private float unbeatableTime = 0;
        //主相机
        OCameraFollow cam;
        //是否可以控制转向
        private bool rotationEnable = true;
        //是否无敌
        public bool invincible = false;

        void Start()
        {
            //获取动画
            ani = GetComponentInChildren<Animator>();

            Shader shader = Shader.Find("Transparent/Diffuse");
            //获取角色
            character = this.transform.GetChild(0).GetComponentsInChildren<Renderer>();
            //获取名字
            namebar = this.transform.GetChild(6).GetComponentsInChildren<Renderer>();
            //获取血条
            healthbar = this.transform.GetChild(5).GetComponentsInChildren<CanvasRenderer>();
            foreach (var render in character)
            {
                //阴影
                render.material.shader = shader;
            }
            //设为可见
            SetTransparent(1f);

            cam = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<OCameraFollow>();
        }

        /// <summary>
        /// 草丛状态，0不在草丛中，1在草丛中且可见（半透明），2不可见
        /// </summary>
        public int OBush
        {
            get => bushStatus;
            set
            {
                //更新透明度。
                bushStatus = value;
                RefreshTransparent();
            }
        }
        private int bushStatus;

        /// <summary>
        /// 根据当前状态（目前为草丛、隐身技能）刷新透明度
        /// </summary>
        private void RefreshTransparent()
        {
            if (invisibleTime <= 0)
            {//隐身技能未生效
                switch (bushStatus)
                {
                    case 0:
                        SetTransparent(1f);
                        break;
                    case 1:
                        SetTransparent(0.5f);
                        break;
                    case 2:
                        SetTransparent(0f);
                        break;
                }
            }
            //隐身技能生效
            else if (team == cam.team)
            {//是队友
                SetTransparent(0.5f);
            }
            else
            {//不是队友
                SetTransparent(0f);
            }
        }

        //当前透明度，减少SetTransparent工作量
        private float currenta;
        /// <summary>
        /// //设置可见度
        /// </summary>
        /// <param name="a">透明度\in[0,1]</param>
        private void SetTransparent(float a)
        {
            //若透明度不变则无需动作
            if (currenta != a)
            {
                currenta = a;
                //设置角色可见度
                foreach (var render in character)
                {
                    render.material.color = new Color(1f, 1f, 1f, a);
                }
                //设置血条可见度
                foreach (var render in healthbar)
                {
                    render.SetAlpha(a);
                }
                //设置名字可见度
                foreach (var render in namebar)
                {
                    render.enabled = a != 0;
                }
            }
        }
        /// <summary>
        /// 待合并
        /// 死亡时应invoke deathevent
        /// </summary>
        public void Dead()
        {
            deathevent.Invoke(this);
        }

        /// <summary>
        /// 待合并
        /// 攻击时应使隐身技能失效
        /// </summary>
        public void Attack()
        {
            invisibleTime = 0;
            RefreshTransparent();
        }

        //Author: Via Cytus

        /// <summary>
        /// 角色移动动画
        /// </summary>
        void Update()
        {
            //移动
            //获取摇杆向量
            Vector3 direction = new Vector3(touch.Movement.x, 0, touch.Movement.y);
            //获取角色控制插件
            CharacterController controller = GetComponent<CharacterController>();
            if (direction != Vector3.zero)
            {
                //add by wmj
                //移动重置隐身
                invisibleTime = 0;
                RefreshTransparent();
                //wmj ends
                if (rotationEnable == true)
                {
                    //旋转
                    transform.rotation = Quaternion.Lerp(transform.rotation, Quaternion.LookRotation(direction), Time.deltaTime * 10);
                    //移动
                    transform.Translate(Vector3.forward * Time.deltaTime * speed);

                    //设置动画
                    ani.SetFloat("Speed", speed);
                    //角色控制插件控制移动
                    controller.SimpleMove(direction * speed);
                }
            }
            else
            {
                //停止动画
                ani.SetFloat("Speed", 0);
            }
            //Author: wmj
            //隐身
            if (invisibleTime > 0)
            {
                //更新隐身时长
                invisibleTime -= Time.deltaTime;
                //隐身技能结束
                if (invisibleTime <= 0)
                {
                    invisibleTime = 0;
                    RefreshTransparent();
                }
            }
            //Author Via Cytus
            //突进
            if (marchForwardTime > 0)
            {
                //突进
                transform.Translate(Vector3.forward * Time.deltaTime * distance / (float)0.2);
                //角色控制插件控制移动
                controller.SimpleMove(transform.forward * distance / (float)0.2);
                //技能持续时间减少
                marchForwardTime -= Time.deltaTime;
                if (marchForwardTime <= 0 )
                {
                    //允许转向
                    rotationEnable = true;
                }
            }
            //加速
            if (accelerateTime > 0)
            {
                accelerateTime -= Time.deltaTime;
                //加速结束
                if (accelerateTime < 0)
                {
                    speed = speed / (1 + speedUp);
                    accelerateTime = 0;
                }
            }
            //无敌
            if (unbeatableTime > 0)
            {
                unbeatableTime -= Time.deltaTime;
                //无敌
                invincible = true;
                //无敌结束
                if (unbeatableTime <= 0)
                {
                    invincible = false;
                }
            }
        }

        //Author Via Cytus
        public void SkillTrigger()
        {
            switch (skillNumber)
            {
                case 1: MarchForward(); break;
                case 2: Accelerate(); break;
                case 3: Invisible(); break;
                case 4: Unbeatable(); break;
            }
        }

        /// <summary>
        /// 突进技能
        /// </summary>
        private void MarchForward()
        {
            //添加音效
            AudioSource music;
            music = transform.GetComponentsInChildren<AudioSource>()[0];
            music.Play();
            marchForwardTime = 0.2;
            //禁止转向
            rotationEnable = false;
        }

        /// <summary>
        /// 加速技能
        /// </summary>
        private void Accelerate()
        {
            //添加音效
            AudioSource music;
            music = transform.GetComponentsInChildren<AudioSource>()[1];
            music.Play();
            //加速
            speed = speed * (1 + speedUp);
            accelerateTime = accelerateDuration;
        }

        /// <summary>
        /// 使用隐身技能时调用此方法
        /// </summary>
        private void Invisible()
        {
            //添加音效
            AudioSource music;
            music = transform.GetComponentsInChildren<AudioSource>()[2];
            music.Play();
            invisibleTime = invisibleDuration;
            RefreshTransparent();
        }

        /// <summary>
        /// 无敌技能
        /// </summary>
        private void Unbeatable()
        {
            unbeatableTime = unbeatableDuration;
        }
    }
}