with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_Line;
with Ada.Strings;
with Ada.Task_Identification; use Ada.Task_Identification;
with ada.numerics.discrete_random;

procedure Main is

   type Par_De_Pisos is record
      Floor_From, Floor_To: Integer;
   end record;

   Task type Semaforo is
      Entry preguntarEstado(state : OUT Integer);
      Entry wait;
      Entry signal;
   End Semaforo;

   Task body Semaforo is
      estado: integer := 1;
   begin
      Loop
         select
            accept signal;
            estado:=estado + 1;
         or
            accept preguntarEstado(state : OUT integer) do
               state:=estado;
            End;
         or
            accept wait;
            estado:=estado - 1;
         or
            terminate;
         end select;
      End loop;
   end Semaforo;


   Suno : Semaforo;
   Sdos : Semaforo;

   Task type irAlFrom is
      entry ir(w : in integer; x : in integer ; y : out integer);
      entry empezar(w : IN integer);
   end irAlFrom;
   Task body irAlFrom is
      z : integer;
      anterior : integer := 0;
      ir1 : integer ;
      ir2 : integer;
   begin
      accept empezar(w : IN integer) do
         z := w;
      end empezar;
      loop
         accept ir(w : in integer; x : in integer ; y : out integer) do
            ir1 := w;
            ir2 := x;
            y := ir2;
         end ir;
         if z = 1 then
            Suno.wait;
         else
            Sdos.wait;
         end if;
         Put_Line ("- " & z'Image & " Elevator moving from floor" & anterior'Image & " to" & ir1'Image);
         delay 1.0;
         Put_Line ("- " & z'Image & " Elevator moving from floor" & ir1'Image & " to" & ir2'Image);
         anterior := ir2;
         delay 1.0;
         if z = 1 then
            Suno.signal;
         else
            Sdos.signal;
         end if;
      end loop;
   end irAlFrom;

   uno : irAlFrom;
   dos : irAlFrom;


   Task type trabajo is
      entry agregar(w : in Par_De_Pisos);
      entry empezar(w : in integer; y : in integer);
   end trabajo;
   Task body trabajo is

      dondeEstaUno : integer := 0;
      dondeEstaDos : integer := 0;

      estado1 : integer := 1;
      estado2 : integer := 1;

      ir1 : integer;
      ir2 : integer;

      diferencia1 : integer;
      diferencia2 : integer;

   begin
      accept empezar(w : in integer; y : in integer) do
         uno.empezar(w);
         dos.empezar(y);
      end empezar;
      loop
         accept agregar(w : in Par_De_Pisos) do


            ir1 := w.Floor_From;
            ir2 := w.Floor_To;

            Suno.preguntarEstado(estado1);
            Sdos.preguntarEstado(estado2);
            while estado1 = 0 and estado2 = 0 loop
               delay 1.0;
               Suno.preguntarEstado(estado1);
               Sdos.preguntarEstado(estado2);
            end loop;

            if estado1 = 0 and estado2>0 then
               dos.ir(ir1, ir2 , dondeEstaDos);

            elsif estado2 = 0 and estado1>0 then
               uno.ir(ir1, ir2 ,  dondeEstaUno);

            elsif estado1 > 0 and estado2 > 0 then
               diferencia1 := dondeEstaUno - ir1;
               diferencia2 := dondeEstaDos - ir1;

               if abs(diferencia2) < abs(diferencia1) then
                  dos.ir(ir1, ir2 , dondeEstaDos);
               else
                  uno.ir(ir1, ir2 ,  dondeEstaUno);
               end if;
            end if;

         end agregar;
      end loop;
   end trabajo;



  -- prueba : Par_De_Pisos := (Floor_From => 0, Floor_To => 5);
  --prueba1 : Par_De_Pisos := (Floor_From => 0, Floor_To => 3);
  -- prueba2 : Par_De_Pisos := (Floor_From => 6, Floor_To => 2);
  -- prueba3 : Par_De_Pisos := (Floor_From => 3, Floor_To => 8);
  -- prueba4 : Par_De_Pisos := (Floor_From => 1, Floor_To => 9);
  -- prueba5 : Par_De_Pisos := (Floor_From => 2, Floor_To => 3);
  -- prueba6 : Par_De_Pisos := (Floor_From => 0, Floor_To => 3);
  -- prueba7 : Par_De_Pisos := (Floor_From => 1, Floor_To => 5);
  -- prueba8 : Par_De_Pisos := (Floor_From => 10, Floor_To => 0);
  -- prueba9 : Par_De_Pisos := (Floor_From => 4, Floor_To => 0);

   S : trabajo;

   type randRange is new Integer range 0..10;  -- genero numeros aleatorios en este rango
   package Rand_Int is new ada.numerics.discrete_random(randRange);
   use Rand_Int;
   gen : Generator;
   numM : randRange;   -- para guardar el numero aleatorio generado para poder mostrarlo del Main
   numN : randRange;
   Input_Number : Integer;


begin
   Put_Line ("Bienvenido al edificio!");
   S.empezar(1,2);
   Put_Line("Ingrese numero de pedidos: ");
   Get(Input_Number);
   while Input_Number /= 0 loop
      reset(gen);
      numM :=random(gen);
      numN := random(gen);
      S.agregar((Floor_From => Integer (numM), Floor_To => Integer (numN)));
      Input_Number :=  Input_Number - 1;
   end loop;

   null;
end Main;
