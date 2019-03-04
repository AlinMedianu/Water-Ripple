using UnityEngine;

public class WaterAnimator : MonoBehaviour
{
    [SerializeField]
    private float duration = 1f;
    private float timer;
    private float timerMultiplier;
    private Material water;
    private Camera viewer;

    private void Start()
    {
        ResetTimer();
        water = GetComponent<MeshRenderer>().material;
        viewer = FindObjectOfType<Camera>();
    }

    private void OnValidate()
    {
        ResetTimer();
    }

    private void Update()
    {
        if(timer < duration)
        {
            water.SetFloat("rippleLength", timer * timerMultiplier);
            timer += Time.deltaTime;
        }
    }

    private void OnMouseDown()
    {
        if (timer >= duration && Physics.Raycast(viewer.
            ScreenPointToRay(Input.mousePosition), out RaycastHit contact))
        {
            timer = 0;
            water.SetFloat("rippleHeight", 1);
            water.SetVector("ripplePosition", contact.textureCoord);
        }
    }

    private void ResetTimer()
    {
        timer = duration;
        timerMultiplier = 10 / duration;
    }
}
