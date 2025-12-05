
#define VIDEO_MEMORY ((volatile char*) 0xB8000)
#define VGA_MEMORY_SIZE 4000


#define WHITE_ON_BLACK 0x0F
#define NEON 0x0B
#define HACKER 0x0A
#define ERROR 0x0C


void printchar(int x, int y, char c) {
    char* video_memory = (char*) 0xB8000;
    int offset = (y * 80 + x) * 2; 
    VIDEO_MEMORY[offset] = c;
    VIDEO_MEMORY[offset+1] = 0x0F;
}


// Une pause très approximative
void sleep(int duree) {
    volatile long i = 0;
    while (i < duree * 100000000) {
        i++;
    }
}



void printString(int startX,int startY,char* String) {
    while (*String != 0) {
        char c = *String;
        printchar(startX,startY,c);
        startX++;
        if(startX >80) {
            startX = 0 ;
            startY++;
        }
        String++;
    }
}


void clearScreen(){
    for(int i=0;i<VGA_MEMORY_SIZE;i=i+2) {
        VIDEO_MEMORY[i] = ' ';
    }
}


void main() {
    printString(10,10,"Salut bandes de merdes comment ça va les reuftons de cons ?");
    clearScreen();
    printString(1,1,"Lancement de Bastos......");
    sleep(10);
    clearScreen();
    printString(1,1,"Bastos prêt ......");
    clearScreen();

    while (1) {
        printString(2,2,">_");
        sleep(2);
        printString(2,2,"> ");
        sleep(2);

    }
}
