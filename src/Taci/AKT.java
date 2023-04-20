

package Taci;
import java.util.*;

public class AKT {

    public static Set<State> closed = new HashSet<State>();
    public static State goal;

    public AKT(State goal) {
        this.goal=goal;
    }
    public void printList(List<State> l) {
    	for (State i : l) {
            printMatrix(i);

    	}
    }
     
    public void AKTSearch(State startState) {
    	int loop=0;
        PriorityQueue<State> openQueue = new PriorityQueue<>();
        openQueue.add(startState);

        while(!openQueue.isEmpty()){

        loop++;	
        System.out.println("----------------------------at loop ---"+ loop);

            State currentState = openQueue.poll();

         
            if(currentState.getH()==0) {
                printMatrix(currentState);

                System.out.println("------win the puzzle-------at loop ---"+ loop);
            	currentState.tracePath().printPath();
                printMatrix(currentState);
                break;
            }

         List<State> adjacentStates = currentState.getAdjacentStates();
         System.out.println("Current State---G: "+currentState.getG()+" H: "+currentState.getH()+" F: "+currentState.getF());
         printMatrix(currentState);
       	 System.out.println("AdjacentStates:   ");

  
           for (int i = 0; i < adjacentStates.size(); i++) {
                State v = adjacentStates.get(i);
                if((v!=null) && !(isClosed( v))&& ( !openQueue.contains(v)) ) { 
                	v.setG(currentState.getG()+1);
                    printMatrix(v);

                    openQueue.add(v);

                }
            }
         	 System.out.println("Open:   " + openQueue.size());


           
         closed.add(currentState);
        
         if (loop%200==00) {
           System.out.println("--------------------------------------------start loop--"+loop);
         printMatrix(currentState);       	
        	}

        }
    }
    
    
    public boolean isClosed(State s) {
    	boolean result=false ;
    	for  (State i: closed) {
    		if (i.compareTo(s)==0) {
    			result=true;
    		}
    	}
    	return result;
    }
    
    public static void printMatrix(State m) {
    	List a=m.getArray();
        System.out.println(a.get(0)+" "+a.get(1)+" "+a.get(2));
        System.out.println(a.get(3)+" "+a.get(4)+" "+a.get(5));
        System.out.println(a.get(6)+" "+a.get(7)+" "+a.get(8));
        System.out.println("---G: "+m.getG()+" H: "+m.getH()+" F: "+m.getF());

    }

    public static void main(String[] args) {
    	State start=new State(new ArrayList<Integer>(Arrays.asList(new Integer[]{2,8,3,1,6,4,7,0,5})));
//    	State start=new State(new ArrayList<Integer>(Arrays.asList(new Integer[]{2,8,1,0,4,3,7,6,5})));
    	int m[][] ={{1,2},{3,4}};
    	start.setG(0);
        goal=new State(new ArrayList<Integer>(Arrays.asList(new Integer[]{1,2,3,8,0,4,7,6,5})));
        AKT at = new AKT(goal);
        
       
        at.AKTSearch(start);
    }
}
