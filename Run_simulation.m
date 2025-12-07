%NAREK STEPANYAN
%MODELIZACION MECANICA DE ELEMENTOS ESTRUCTURALES



% INFORMACION DE LOS G.L Y Nº DE NODOS
ngn=1;
maxnod=4;
ngt=ngn*maxnod;
maxel=maxnod-1;

% RESERVAR MEMORIA PARA LAS VARIABLES
id= zeros(maxnod, ngn);
x= zeros(maxnod, 1);

% CREAMOS LOS DATOS Y ASIGNAMOS LAS VARIABLES 
coor= load ('coordinates.txt');
x=coor(:,2);
id=coor(:,5);

% ALGORITMO SELECCION DE ECUACIONES
maxeq=0;
for i=1:maxnod
    if id(i,ngn)==0
        maxeq=maxeq + 1;
        id(i,ngn)=maxeq;
    else 
        id(i,ngn)=0;
    end
end

% PROPIEDADES MATERIAL

krig= load ('material_properties.txt');
k1= krig(1,2);
k2= krig(2,2);
k3= krig(1,2);
k=[k1 k2 k3];
ke=[1 -1; -1 +1];
kgl= zeros(maxeq, maxeq);

% CONECTIVIDADES ENTRE ELEMENTOS

elem= load('connectivity_matrix.txt');
lm= zeros(maxel, ngn+1);


% ALGORITMO PRINCIPAL (ENSAMBLA ELEMENTOS EN LA MATRIZ GLOBAL)

c=0;
for i=1:maxel
    ni=elem(i,2);
    nf=elem(i,3);
    lm=[id(ni,1) id(nf,1)];
    dimlm=length(lm);
    c= c+1;
        for ii=1:dimlm
            ig= lm(ii);
                if(ig==0)
                continue
                end
        for jj=1:dimlm
            jg= lm(jj);
                if(jg==0)
                continue
                end
kgl(ig,jg)=kgl(ig,jg)+k(c)*ke(ii,jj);

end
end
end

            
% FICHERO DE LA CARGA

cc=load('loads.txt');
maxc=length(cc(:,1));
ff=zeros(maxeq,1);

for il=1:maxc
    nn=cc(il,1);
    carga=cc(il,2);
    lmc=[id(nn,1)];
    for jl=1:ngn
        jg=lmc(jl);
        
        if jg==0
        continue
        end
        ff(jg)=ff(jg)+carga(jl);
    end
end    


%*********************RESULTADOS*******************

% DESPLAZAMIENTOS DE LOS NUDOS 
printf('Estos son los desplazamientos relativos de los\nnodos intermedios 2 y 3 (mm)\n')
u=inv(kgl)*ff


u_gl=zeros(maxnod,1);

 for i=1:maxnod
    ngl=id(i,1);
    if (ngl==0)
    u_gl(i)=0;
    else
    u_gl(i)=u(ngl);    
    end
end   
    
% FUERZAS EN LOS NODOS
printf('Fuerzas en los nodos intermedios 2 y 3 (N)\n')
fnod=zeros(2,1);
fnod=kgl*u


% REPRESENTACION GRAFICA
x=[0;20;40;60];
y1=[0;0;0;0];
y2=y1;

x2=[0;(20+u(1)/1);(40+u(2)/1);60];
plot (x, y1,'*', x2, y1,'o')
grid on;
xlabel ("Desplazamientos de los nodos en mm");
h=legend ("Posiciones iniciales", "Posiciones finales");
set (h, "fontsize", 12);
