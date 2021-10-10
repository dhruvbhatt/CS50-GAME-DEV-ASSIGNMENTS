using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {
Scene scene;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1) {
			scene=SceneManager.GetActiveScene();
			if (scene.name=="Title")
			{
				SceneManager.LoadScene("Play");

			}
			else
			{
				DontDestroy.instance.GetComponents<AudioSource>()[0].Pause();
				
				SceneManager.LoadScene("Title");
			}
		}
	}
}
