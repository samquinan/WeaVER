public interface Button{
	void display();
	void setActive(boolean b);
	boolean isActive();
	boolean interact(int mx, int my);
	boolean clicked(int mx, int my);
	boolean released();
}