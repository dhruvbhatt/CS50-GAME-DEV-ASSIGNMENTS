using UnityEngine;
using UnityEngine.UI;
using System.Collections;
//[RequireComponent(typeof(Text))]
public class textspawn : MonoBehaviour {

	private Text text;
	private int coins;

	// Use this for initialization
	void Start () {
		text = GetComponent<Text>();
	}

	// Update is called once per frame
	void Update () {
		
			coins = LevelGenerator.level;
		
		text.text = "LEVEL: " + coins;
	}
}