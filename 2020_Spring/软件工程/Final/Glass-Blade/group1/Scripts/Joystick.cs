//Author: wmj


using UnityEngine;
using UnityEngine.EventSystems;

public class Joystick : MonoBehaviour, IPointerDownHandler, IDragHandler, IPointerUpHandler
{
    public Transform handle;        //摇杆
    public RectTransform panel;     //轮盘
    public int maxradius=80;           //最大位移
    public Vector2 Movement { get => movement; }        //获取位移

    private Vector2 movement;       //位移

    public void OnDrag(PointerEventData eventData)
    {
        //可能需要区分pointerID
        RectTransformUtility.ScreenPointToLocalPointInRectangle(panel, eventData.position, eventData.pressEventCamera, out Vector2 position);       //获取按钮位置
        position = position.normalized * (position.magnitude > maxradius ? maxradius : position.magnitude);         //限制位移大小
        movement = position / maxradius;        //设成对于最大位移的比例
        handle.localPosition = position;        //设置轮盘相对位移
    }

    //处理按钮事件
    public void OnPointerDown(PointerEventData eventData)
    {
        OnDrag(eventData);
    }
    
    //归零
    public void OnPointerUp(PointerEventData eventData)
    {
        movement = handle.localPosition = Vector2.zero;
    }

    //Author: Via Cytus
    //使用WASD控制移动

    void Update()
    {
        Vector2 position = new Vector2(0, 0);

        if (Input.GetKey("w"))
        {
            position.y++;
        }
        if (Input.GetKey("w"))
        {
            movement = position.normalized;
            handle.localPosition = position;
        }
        if (Input.GetKeyUp("w"))
        {
            movement = handle.localPosition = Vector2.zero;
        }


        if (Input.GetKey("a"))
        {
            position.x--;
        }
        if (Input.GetKey("a"))
        {
            movement = position.normalized;
            handle.localPosition = position;
        }
        if (Input.GetKeyUp("a"))
        {
            movement = handle.localPosition = Vector2.zero;
        }


        if (Input.GetKey("s"))
        {
            position.y--;
        }
        if (Input.GetKey("s"))
        {
            movement = position.normalized;
            handle.localPosition = position;
        }
        if (Input.GetKeyUp("s"))
        {
            movement = handle.localPosition = Vector2.zero;
        }


        if (Input.GetKey("d"))
        {
            position.x++;
        }
        if (Input.GetKey("d"))
        {
            movement = position.normalized;
            handle.localPosition = position;
        }
        if (Input.GetKeyUp("d"))
        {
            movement = handle.localPosition = Vector2.zero;
        }
    }
}
