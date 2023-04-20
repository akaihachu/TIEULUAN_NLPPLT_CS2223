/*
    Nguyen Tuan Dang
    Faculty of Information Technology, Saigon University
    dangnt@sgu.edu.vn
*/

package Taci;
import java.util.ArrayList;
import java.util.List;

public class Path<T> {
    private List<T> path;
    
    public Path(){
        path = new ArrayList<>();
    }
    
    public void addVertex(T vertex) {
        path.add(vertex);
    }
    
    public List<T> getPath(){
        return path;
    }
    
    public void setPath(List<T> path){
        this.path.addAll(path);
    }

    public void printPath(){
        for (int i = path.size()-1; i >0; i--){
        	AKT.printMatrix((State)path.get(i));
        }
        
        System.out.println();
    }    
}
