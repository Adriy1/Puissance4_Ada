with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;

package body Puissance4 is


  procedure Initialiser(E : out Etat) is
    I:Integer;
  begin
    I := 0;
    for I in 0..(largeur*hauteur-1) loop
      E(I) := 0;
    end loop;
  end Initialiser;

  function Jouer(E : in out Etat; C : Coup) return Etat is
    I:Integer;
  begin
    I := 0;
    while E(C.Col*hauteur+I) /= 0  loop --on place I a la bonne hauteur
      I := I+1;
    end loop;
    if C.Player = Joueur1 then -- on remplace la case par la bonne valeur
      E(C.Col*hauteur+I) := 1;
    else
      E(C.Col*hauteur+I) := 2;
    end if;
    return E;
  end Jouer;

  function Est_Gagnant(E : Etat; J : Joueur) return Boolean is
    I : Integer;
    S : Integer;
    K1 : Integer;
    K2 : Integer;
    X : Integer;
  begin
    I := 0;
    S := 0;
    if J = Joueur1 then
      X := 1;
    else
      X := 2;
    end if;
    for I in E'range loop  -- boucle pour parcourir la grille verticalement
      if I mod hauteur = 0 or E(I) /= X then
        S := 0;
      end if;
      if E(I) = X then
        S := S + 1;
        if S = nbp then
          Put_Line("LE JOUEUR "& integer'image(X) &" A GAGNE !!");
          return true;
        end if;
      end if;
    end loop;
    I := 0;
    S := 0;
    K1 := -1;
    K2 := 0;
    for I in E'range loop -- boucle pour parcourir la grille horizontalement
      if I mod hauteur = 0 then
        K1 := K1 + 1;
        K2 := 0;
      end if;
      if I mod hauteur = 0 or E(K2+K1) /= X then
        S := 0;
      end if;
      if E(K2+K1) = X then
        S := S + 1;
        if S = nbp then
          Put_Line("LE JOUEUR "& integer'image(X) &" A GAGNE !!");
          return true;
        end if;
      end if;
      K2 := K2 + largeur;
    end loop;
    I := 0;
    S := 0;
    for I in E'range loop --boucle pour la diagonale /
      K2 := I/hauteur;
      K1 := 0;
      if E(I) = X then
        S := S + 1;
        while (I+K1+hauteur+1)/hauteur = K2+1 and (I+K1+hauteur+1) < largeur*hauteur-1 loop
          K2 := K2 +1;
          K1 := K1 + hauteur + 1;
          if E(I+K1) /= X then
            S := 0;
          else
            S := S + 1;
            if S = nbp then
              Put_Line("LE JOUEUR "& integer'image(X) &" A GAGNE !!");
              return true;
            end if;
          end if;
        end loop;
      else
        S := 0;
      end if;
    end loop;
    I := 0;
    S := 0;
    K2 := 0;
    for I in E'range loop  --boucle pour la diagonale \
      K2 := I/hauteur;
      K1 := 0;
      if E(I) = X then
        S := S + 1;
        while (I+K1-hauteur+1)/hauteur = K2-1 and (I+K1-hauteur+1) > -1 loop
          K2 := K2 - 1;
          K1 := K1 - hauteur + 1;
          if E(I+K1) /= X then
            S := 0;
          else
            S := S + 1;
            if S = nbp then
              Put_Line("LE JOUEUR "& integer'image(X) &" A GAGNE !!");
              return true;
            end if;
          end if;
        end loop;
      else
        S := 0;
      end if;
    end loop;
    return false;
  end Est_Gagnant;

  function Est_Nul(E : Etat) return Boolean is
    I : Integer;
    J : Joueur;
  begin
    I := 0;
    for I in E'range loop
      if E(I) = 0 then
      --  Put("Game is not Over !");
        return false;
      end if;
    end loop;
    J := Joueur1;
    if Est_Gagnant(E,J) = false then
      J := Joueur2;
      if Est_Gagnant(E,J) = false then
        Put_Line("MATCH NUL !!");
        return true;
      end if;
    end if;
    return false;
  end Est_Nul;

  procedure Affiche_Jeu(E : Etat) is
    I : Integer;
    J : Integer;
  begin
    J := 0;
    I := 0;
    Put_Line("  ");
    for I in 0..(largeur-1) loop
      Put(" ");
      Put(Integer'image(I) & " ");
    end loop;
    Put_Line(" ");
    I := 0;
    for J in 0..hauteur-1 loop
      for I in 0..largeur-1 loop
        if E(I*hauteur+hauteur-J-1) = 1 then
          Put("| X ");
        else if E(I*hauteur+hauteur-J-1) = 2 then
            Put("| O ");
          else
            Put("|   ");
          end if;
        end if;
      end loop;
      Put_Line("|");
    end loop;
    Put_Line(" ");
  end Affiche_Jeu;


procedure Affiche_Coup(C : in Coup) is
begin
  if C.Player = Joueur2 then
    Put("Joueur2 joue ");Put(C.Col);New_Line;
  else
    Put("Joueur1 joue ");Put(C.Col);New_Line;
  end if;
  Put_Line(" ");
end Affiche_Coup;



function Demande_Coup_Joueur1(E : Etat) return Coup is
    C : Coup;
    B : Boolean;
    T : Boolean;
  begin
    C.Player := Joueur1;
    B := false;
    T := false;
    while (B = false or T = false) loop
      Put_Line("Joueur1 prochain coup ?");
      Get(C.Col);
      if C.Col>=largeur or C.Col<0 then
      Put("Error: Cout Impossible");
      else
        B := true;
        if E(C.Col*hauteur+hauteur-1) /= 0 then
          Put("Error: Cout Impossible");
        else
          T := true;
        end if;
      end if;
    end loop;
    return C;
  end Demande_Coup_Joueur1;

  function Demande_Coup_Joueur2(E : Etat) return Coup is
      C : Coup;
      B : Boolean;
      T : Boolean;
    begin
      C.Player := Joueur2;
      B := false;
      T := false;
      while (B = false or T = false) loop
        Put_Line("Joueur2 prochain coup ?");
        Get(C.Col);
        if C.Col>=largeur or C.Col<0 then
        Put("Error: Cout Impossible");
        else
          B := true;
          if E(C.Col*hauteur+hauteur-1) /= 0 then
            Put("Error: Cout Impossible");
          else
            T := true;
          end if;
        end if;
      end loop;
      return C;
    end Demande_Coup_Joueur2;









end Puissance4;
