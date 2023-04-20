package Taci;

import java.util.ArrayList;
import java.util.List;


public class State<T extends List<Integer>> implements Comparable<State>{
//	private List arr;
	private State parent;
	private int step_order=0;
    private T list;


public State(T list) {
	this.list=list;
}




public List getArray() {
	return list;
}
public List<State> getAdjacentStates() {
	 List<State>  neibours=new ArrayList<State>();
	 String[] directions= {"Up","Down","Left","Right"};
	 for (String element : directions) {
		 if( getAdjacentState(element)!= null){
			    neibours.add(getAdjacentState(element));
		 }
		}
	 
	return neibours;
}
private Integer zeroPosition() {
	if (list.indexOf(0)==-1){
		return null;
	} else
	{
		return list.indexOf(0);
	}			
}
public void setParent(State parent) {
	this.parent=parent;
}
public State getParent() {
	return parent;
}


private State getAdjacentState(String direction) {
	if (direction=="Up" && zeroPosition()<=2) {
		return null;
	} else if (direction=="Up" && zeroPosition()>2){
		List res = new ArrayList(list);
		res.set(zeroPosition(), list.get(zeroPosition()-3));
		res.set(zeroPosition()-3, 0);
		State result=new State(res);
		result.setParent(this);
		return result;
	}	
	
	if (direction=="Down" && zeroPosition()>5) {
		return null;
	} else if (direction=="Down" && zeroPosition()<=5){
		List res = new ArrayList(list);
		res.set(zeroPosition(), list.get(zeroPosition()+3));
		res.set(zeroPosition()+3, 0);
		State result=new State(res);
		result.setParent(this);
		return result;	}	
	
	if (direction=="Left" && ((zeroPosition() % 3)==0)) {
		return null;
	} else if (direction=="Left" && ((zeroPosition() % 3)>0)){
		List res = new ArrayList(list);
		res.set(zeroPosition(), list.get(zeroPosition()-1));
		res.set(zeroPosition()-1, 0);
		State result=new State(res);
		result.setParent(this);
		return result;	}	
	if (direction=="Right" && ((zeroPosition() % 3)==2)) {
		return null;
	} else if (direction=="Right" && ((zeroPosition() % 3)<2)){
		List res = new ArrayList(list);
		res.set(zeroPosition(), list.get(zeroPosition()+1));
		res.set(zeroPosition()+1, 0);
		State result=new State(res);
		result.setParent(this);
		return result;	}	
	return null;
}
public Path tracePath(){
    Path<State> path = new Path();
    State v = this;
    while (v != null){
        path.addVertex(v);
        v = v.getParent();
    }

    return path;
}

public int getG() {
	return step_order;
}
public void setG(int value) {
	step_order=value;
}
public int getF() {	
	return getH()+getG();
}

public int getH() {
	int sum=0;
	for (Object item:list) {
		int row=Math.abs(AKT.goal.list.indexOf(item)/3-list.indexOf(item)/3);
		int col=Math.abs((AKT.goal.list.indexOf(item)%3)-(list.indexOf(item)%3));
		sum+=row+col;
	}
	return sum;
}

@Override
public String toString() {
    return "" + this.list;
}

@Override
public int compareTo(State o) {
	if( o.getArray().equals(list)) {
		return 0;
	} 
	if (this.getF()>=o.getF()) {
		return 1;
	}
	return -1;
}


}
